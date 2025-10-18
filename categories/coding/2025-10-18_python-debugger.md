# Python Script Debugger

## Metadata
- **Date Created**: 2025-10-18
- **Category**: coding
- **Topic Tags**: [python, debugging, error-handling, troubleshooting]
- **Use Case**: Debug Python scripts with errors or unexpected behavior

## The Prompt

Debug the following Python script located at `[FILE_PATH]`:

**Issue Description**: [DESCRIBE_ISSUE]

Please:
1. Identify the error or issue
2. Explain why it's occurring
3. Provide corrected code with inline comments
4. Suggest additional improvements (error handling, optimization, best practices)
5. Include test cases to verify the fix

If the issue is unclear, review the entire script and identify potential bugs, anti-patterns, or improvements.

## Context/Variables

- `[FILE_PATH]`: Path to Python script
- `[DESCRIBE_ISSUE]`: Brief description of problem (error message, unexpected output, etc.)

## Expected Output

- Root cause analysis
- Corrected code with explanations
- Prevention strategies
- Testing recommendations

## Notes

- Include full error traceback when available
- For large scripts, focus on problematic sections
- Consider Python version compatibility

## Performance
- **Tested**: Y
- **Model**: Claude Sonnet 4.5
- **Success Rate**: 90%
- **Average Time**: 20-90 seconds depending on complexity

## Revision History
- 2025-10-18: Initial creation
