# Neo4j Management — Troubleshooting

Edge cases: Neo4j running, workspace auto-detection failed.

## Path found but workspace unknown

Neo4j running in path not following standard `temp/<workspace>/tools/...` layout.

**Step 1:** Ask user:

> "Neo4j running in `<path>` but workspace auto-detection failed. Do you know which workspace directory this belongs to?"

- User provides workspace \u2192 `cd` into it, continue normally with `startNeo4j.sh` / `stopNeo4j.sh`.

**Step 2:** User unknown or Neo4j outside pipeline \u2014 manual control:

Locate `bin/` dir (contains `neo4j` or `neo4j.bat`), then:

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

Neo4j running, detect script couldn't read path from process.

**Step 1:** Ask user to run:

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

**Step 2:** From output, help user identify Neo4j home path:
- Look for `--home-dir=<path>` in the command line (Neo4j 5+)
- Or `-Dneo4j.home=<path>` (Neo4j 4)
- Or classpath entry ending in `/lib/*` — strip `/lib/*` = home

**Step 3:** Path known → follow "Path found but workspace unknown" above.
