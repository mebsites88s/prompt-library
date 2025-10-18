# File Organization Script

## Metadata
- **Date Created**: 2025-10-18
- **Category**: automation
- **Topic Tags**: [file-management, organization, automation, python, powershell]
- **Use Case**: Automatically organize files in directories by type, date, or custom rules

## The Prompt

Create a file organization script for the directory: `[TARGET_PATH]`

**Organization Strategy**: [by-type/by-date/by-size/custom]

Requirements:
1. Scan directory for files matching criteria
2. Create organized folder structure
3. Move/copy files to appropriate locations
4. Generate log of actions taken
5. Include dry-run mode for testing
6. Add error handling and rollback capability

**Custom Rules** (if applicable): [DESCRIBE_RULES]

Provide script in: [Python/PowerShell/Bash]

## Context/Variables

- `[TARGET_PATH]`: Directory to organize
- `[ORGANIZATION_STRATEGY]`: How to organize files
- `[DESCRIBE_RULES]`: Custom organization logic if needed
- Script language preference

## Expected Output

Complete executable script with:
- Configuration section for easy customization
- Dry-run mode
- Detailed logging
- Progress feedback
- Undo/rollback instructions

## Notes

- Always test with dry-run first
- Backup important files before running
- Consider file permissions on Windows
- Can be scheduled with Task Scheduler (Windows) or cron (Linux/Mac)

## Performance
- **Tested**: Y
- **Model**: Claude Sonnet 4.5
- **Success Rate**: 95%
- **Average Time**: 1-2 minutes to generate script

## Revision History
- 2025-10-18: Initial creation
