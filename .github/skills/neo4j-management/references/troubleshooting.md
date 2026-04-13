# Neo4j Management — Troubleshooting

Reference for edge cases where Neo4j is running but the analysis workspace cannot be determined automatically.

## Path found but workspace unknown

Neo4j is running in a path that does not follow the standard `temp/<workspace>/tools/...` layout.

**Step 1:** Ask the user:

> "Neo4j is running in `<path>` but I could not determine the analysis workspace automatically. Do you know which workspace directory this belongs to?"

- If the user provides the workspace → `cd` into it and continue normally with `startNeo4j.sh` / `stopNeo4j.sh`.

**Step 2:** If the user does not know or says Neo4j is running outside the pipeline, help with manual control:

Locate the `bin/` directory inside the detected path (contains `neo4j` or `neo4j.bat`), then:

```shell
# Stop (Linux/macOS)
NEO4J_HOME=<path> <path>/bin/neo4j stop

# Stop (Windows, Git Bash or CMD)
<path>\bin\neo4j.bat stop
```

If the command above fails:

```shell
# Linux/macOS — find the PID and send SIGTERM
kill $(ps -eo pid,command | grep -i neo4j | grep -v grep | awk '{print $1}')

# Force kill if process does not stop after ~30 s
kill -9 $(ps -eo pid,command | grep -i neo4j | grep -v grep | awk '{print $1}')
```

```powershell
# Windows PowerShell — find and stop Neo4j process
Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
  Where-Object { $_.CommandLine -like '*neo4j*' } |
  Select-Object -ExpandProperty ProcessId |
  Stop-Process -Id
```

## Path undetermined

Neo4j is running but the detect script could not read the path from the process.

**Step 1:** Ask the user to run the appropriate command to find the process:

```shell
# Linux/macOS
ps -eo pid,command | grep -i neo4j | grep -v grep
```

```powershell
# Windows PowerShell
Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
  Where-Object { $_.CommandLine -like '*neo4j*' } |
  Select-Object ProcessId, CommandLine
```

**Step 2:** From the command output help the user identify the Neo4j home path:
- Look for `--home-dir=<path>` in the command line (Neo4j 5+)
- Or `-Dneo4j.home=<path>` (Neo4j 4)
- Or a classpath entry ending in `/lib/*` — strip `/lib/*` to get the home

**Step 3:** Once the path is known, follow the "Path found but workspace unknown" section above.
