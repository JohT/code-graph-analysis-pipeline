import typing
from collections.abc import Callable

import pandas as pd
import numpy as np


def __assert_position_column(position_column_to_check: str, data: pd.DataFrame, axis_name: typing.Literal["x", "y"]) -> None:
    assert position_column_to_check.strip(), f"{axis_name}_position_column is required and must be a non-empty string"
    assert pd.api.types.is_numeric_dtype(data[position_column_to_check]), f"{axis_name}_position_column '{position_column_to_check}' must be numeric"


def __calculate_distances_to_center(data: pd.DataFrame, x_position_column: str, y_position_column: str):
    """
    Computes the 2D Euclidean distances from center for every point and returns that as an numpy array.
    """
    __assert_position_column(x_position_column, data, "x")
    __assert_position_column(y_position_column, data, "y")

    center_x = data[x_position_column].mean()
    center_y = data[y_position_column].mean()
    return np.sqrt((data[x_position_column] - center_x)**2 + (data[y_position_column] - center_y)**2)


def __mask_highest_score_columns(
        data: pd.DataFrame,
        score_column: str,
        highest_n: int,
) -> pd.Series:
    """
    Returns a DataDFrame with one unnamed column containing Boolean values for every row of the input data.
    True means that the input data row fulfills the predicate "score from score_column with in the top_n values".
    """
    score_threshold = data[score_column].nlargest(highest_n).iloc[-1]
    return (data[score_column] >= score_threshold)


def __mask_lowest_score_columns(
        data: pd.DataFrame,
        score_column: str,
        lowest_n: int,
) -> pd.Series:
    """
    Returns a DataDFrame with one unnamed column containing Boolean values for every row of the input data.
    True means that the input data row fulfills the predicate "score from score_column with in the top_n values".
    """
    score_threshold = data[score_column].nsmallest(lowest_n).iloc[-1]
    return (data[score_column] <= score_threshold)


def __zoom_into_center_while_preserving_masked_rows(
        data: pd.DataFrame,
        distances_to_center: np.ndarray,
        mask_for_columns_to_preserve: pd.Series,
        distance_to_center_quantile: float = 0.8,
) -> pd.DataFrame:
    """
    "Zooms in" into the input data DataFrame to focus on the data in the center.
    The numpy array "distances_to_center" contains a distance for every row in the input data.
    All rows outside the "percentile_of_distance_to_center" of this distance will get filtered out.
    However, fields that are marked with true by <mask_for_columns_to_preserve> remain in the DataFrame even if they are outside the distance quantile.
    """
    if data.shape[0] != distances_to_center.size:
        raise ValueError("Error: The number of rows in the data need to match the length of the distances_to_center.")
    distance_to_center_threshold = np.quantile(distances_to_center, distance_to_center_quantile)
    return data[(distances_to_center <= distance_to_center_threshold) | mask_for_columns_to_preserve]


def zoom_into_center(
        data: pd.DataFrame,
        x_position_column: str,
        y_position_column: str,
        percentile_of_distance_to_center: float = 0.8
) -> pd.DataFrame:
    """
    "Zooms in" into the input data DataFrame to focus on the data in the center.
    Only rows outside within the "percentile_of_distance_to_center" will remain in the returned DataFrame.
    """
    distances_to_center = __calculate_distances_to_center(data, x_position_column, y_position_column)
    no_exceptions_dummy_mask = pd.Series(False, index=data.index)
    return __zoom_into_center_while_preserving_masked_rows(data, distances_to_center, no_exceptions_dummy_mask, percentile_of_distance_to_center)


def zoom_into_center_while_preserving_top_scores(
        data: pd.DataFrame,
        x_position_column: str,
        y_position_column: str,
        score_column: str,
        top_n_scores: int = 10,
        lowest_scores: bool = False,
        percentile_of_distance_to_center: float = 0.8
) -> pd.DataFrame:
    """
    "Zooms in" into the input data DataFrame to focus on the data in the center.
    Only rows outside within the "percentile_of_distance_to_center" will remain in the returned DataFrame.
    Rows with scores (score_column) within the top_n_scores will remain in the DataFrame 
    even if they are further away from the center.
    """
    distances_to_center = __calculate_distances_to_center(data, x_position_column, y_position_column)
    mask_function = __mask_lowest_score_columns if lowest_scores else __mask_highest_score_columns
    top_score_rows_mask = mask_function(data, score_column, top_n_scores)
    return __zoom_into_center_while_preserving_masked_rows(data, distances_to_center, top_score_rows_mask, percentile_of_distance_to_center)


def zoom_into_center_while_preserving_scores_above_threshold(
        data: pd.DataFrame,
        x_position_column: str,
        y_position_column: str,
        score_column: str,
        score_threshold: float,
        percentile_of_distance_to_center: float = 0.8
) -> pd.DataFrame:
    """
    "Zooms in" into the input data DataFrame to focus on the data in the center.
    Only rows outside within the "percentile_of_distance_to_center" will remain in the returned DataFrame.
    Rows with scores (score_column) above the score_threshold will remain in the DataFrame 
    even if they are further away from the center.
    """
    distances_to_center = __calculate_distances_to_center(data, x_position_column, y_position_column)
    score_above_threshold_mask = (data[score_column] >= score_threshold)
    return __zoom_into_center_while_preserving_masked_rows(data, distances_to_center, score_above_threshold_mask, percentile_of_distance_to_center)


# Defines a default annotation style for plots with matplotlib.
plot_annotation_style: dict = {
    'textcoords': 'offset points',
    'arrowprops': dict(arrowstyle='->', color='black', alpha=0.3),
    'fontsize': 6,
    'backgroundcolor': 'white',
    'bbox': dict(boxstyle='round,pad=0.4',
                 edgecolor='silver',
                 facecolor='whitesmoke',
                 alpha=1
                 )
}


def __truncate(text: str, max_length: int = 26):
    """
    Truncates the input text to match the given maximum length.
    In case it exceeds the maximum length, the last 3 characters are replaced by dots to make the truncation visible.
    """
    if len(text) <= max_length:
        return text
    return text[:max_length - 3] + "..."


def annotate_each(
    data: pd.DataFrame,
    using: Callable,
    name_column: str,
    x_position_column: str,
    y_position_column: str,
    value_column: str = "",
    cluster_label_column: str = "",
    probability_column: str = "",
    **kwargs
):
    if data.empty:
        return

    __assert_position_column(x_position_column, data, "x")
    __assert_position_column(y_position_column, data, "y")
    if value_column:
        assert pd.api.types.is_float_dtype(data[value_column]), f"value_column '{value_column}' must be of type floating point"
    if cluster_label_column:
        assert pd.api.types.is_integer_dtype(data[cluster_label_column]), f"cluster_label_column '{cluster_label_column}' must be of type integer"
    if probability_column:
        assert pd.api.types.is_float_dtype(data[probability_column]), f"probability_column '{probability_column}' must be of type floating point"

    annotation_function = using
    for dataframe_index, row in data.iterrows():
        value_info = f" ({row[value_column]:.4f})" if value_column else ""
        cluster_info = f" (cluster {row[cluster_label_column]})" if cluster_label_column else ""
        probability_info = f" (p={row[probability_column]:.3f})" if probability_column else ""
        annotation_function(
            **plot_annotation_style,
            **kwargs,
            text=f"{__truncate(row[name_column])}{value_info}{cluster_info}{probability_info}",
            xy=(row[x_position_column], row[y_position_column]),
            xytext=(5, 5),
        )


def annotate_each_with_index(
    data: pd.DataFrame,
    using: Callable,
    name_column: str,
    x_position_column: str,
    y_position_column: str,
    value_column: str = "",
    probability_column: str = "",
    **kwargs
):
    if data.empty:
        return

    __assert_position_column(x_position_column, data, "x")
    __assert_position_column(y_position_column, data, "y")
    if value_column:
        assert pd.api.types.is_float_dtype(data[value_column]), f"value_column '{value_column}' must be of type floating point"
    if probability_column:
        assert pd.api.types.is_float_dtype(data[probability_column]), f"probability_column '{probability_column}' must be of type floating point"

    data_in_reversed_order = data.iloc[::-1]  # plot most important annotations last to overlap less important ones

    annotation_function = using
    for dataframe_index, row in data_in_reversed_order.iterrows():
        index = typing.cast(int, dataframe_index)
        y_offset = (index % 5) * 10

        value_info = f" ({row[value_column]:.4f})" if value_column else ""
        probability_info = f" (p={row[probability_column]:.3f})" if probability_column else ""

        annotation_function(
            **plot_annotation_style,
            **kwargs,
            text=f"#{index + 1}: {__truncate(row[name_column])}{value_info}{probability_info}",
            xy=(row[x_position_column], row[y_position_column]),
            xytext=(5, 5 + y_offset),
        )

def scale_marker_sizes(size_values, minimum_size: int = 8, maximum_size: int = 1000, top_fraction: float = 0.1, downscale_factor: float = 0.8):
    """
    Scales numeric size values to a visual range suitable for matplotlib's scatter plot.

    Parameters:
        size_values (array-like): The raw size values to scale.
        minimum_size (float): The smallest marker area (in points^2).
        maximum_size (float): The largest marker area (in points^2).
        top_fraction (float or None): If set, only top values remain fully scaled, others are reduced slightly.
        downscale_factor (float): Factor to reduce sizes below the cutoff (0 < factor < 1).

    Returns:
        np.ndarray: Scaled marker sizes.
    """
    size_values = np.array(size_values)
    smallest_value = size_values.min()
    largest_value = size_values.max()

    # Handle case where all values are the same
    if largest_value == smallest_value:
        normalized_values = np.full_like(size_values, 0.5)
    else:
        normalized_values = (size_values - smallest_value) / (largest_value - smallest_value)

    cutoff = np.quantile(normalized_values, 1.0 - top_fraction)
    cutoff = np.quantile(normalized_values, 1 - top_fraction)
    below_cutoff = normalized_values < cutoff
    normalized_values[below_cutoff] *= downscale_factor
    
    # Scale to desired visual size range
    return normalized_values * (maximum_size - minimum_size) + minimum_size