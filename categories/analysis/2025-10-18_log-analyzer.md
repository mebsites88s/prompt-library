# Log File Analyzer

## Metadata
- **Date Created**: 2025-10-18
- **Category**: analysis
- **Topic Tags**: [logs, troubleshooting, pattern-detection, error-analysis]
- **Use Case**: Analyze log files for errors, patterns, and anomalies

## The Prompt

Analyze the log file at `[LOG_FILE_PATH]`.

**Analysis Focus**: [errors/performance/patterns/security/all]

Provide:
1. Summary of log entries (total lines, date range, log levels)
2. Error analysis (frequency, types, critical issues)
3. Pattern detection (recurring events, time-based patterns)
4. Performance insights (if timestamps present)
5. Anomaly detection (unusual patterns, spikes)
6. Recommendations for investigation or fixes
7. Suggested monitoring alerts based on findings

Use appropriate parsing techniques (regex, line-by-line processing).

## Context/Variables

- `[LOG_FILE_PATH]`: Path to log file
- `[ANALYSIS_FOCUS]`: Specific area of focus or "all" for comprehensive

## Expected Output

- Executive summary of findings
- Error frequency table
- Critical issues highlighted
- Timeline of significant events
- Actionable recommendations

## Notes

- For large logs (>100MB), recommend sampling or chunking
- Works with various log formats (Apache, nginx, application logs, etc.)
- Can identify log format automatically in most cases
- Best results with structured logs (JSON, specific format)

## Performance
- **Tested**: Y
- **Model**: Claude Sonnet 4.5
- **Success Rate**: 90%
- **Average Time**: 30-120 seconds depending on file size

## Revision History
- 2025-10-18: Initial creation
