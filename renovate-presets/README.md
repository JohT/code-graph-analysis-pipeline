# Renovate Presets

This folder contains Renovate presets for updating the code graph analysis workflow. These presets are designed to be used in other repositories to streamline and automate dependency updates.

## Available Presets

### Code Graph Analysis Workflow

This preset is designed to update the dependencies and configurations related to the code graph analysis workflow.

## Usage

To use a preset from this folder in your repository, add the following to your `renovate.json` configuration:

```json
{
    "extends": [
        "github>JohT/code-graph-analysis-pipeline//renovate-presets/<preset-name>.json5"
    ]
}
```

Replace `<preset-name>` with the name of the preset you want to use, e.g., `code-graph-analysis-workflow-latest-digest`.

## Future Presets

In the future, more presets with different options may be added to this folder. These presets will also be publicly available for use in other repositories.

## References

- Available configuration options: https://docs.renovatebot.com/configuration-options
- Shareable configuration presets: https://docs.renovatebot.com/config-presets
- Update of GitHub Actions: https://docs.renovatebot.com/modules/manager/github-actions
