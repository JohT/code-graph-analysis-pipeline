// Create index on symbol property for all SCIP nodes to enable fast lookups.
// This index is used by Import_SCIP_Cross_File_Symbol_Edges.cypher and similar queries
// to avoid expensive full-table scans during edge creation.
// Note: Uniqueness constraints already exist for specific node types;
// this creates a generic index for efficient lookups regardless of node type.

CREATE INDEX scip_symbol_index IF NOT EXISTS FOR (n:SCIP) ON (n.symbol)
