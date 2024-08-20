// Create index for module name

CREATE INDEX INDEX_MODULE_NAME IF NOT EXISTS FOR (module:TS) ON (module.moduleName)