# Technical Documentation Generator

## Metadata
- **Date Created**: 2025-10-18
- **Category**: writing
- **Topic Tags**: [documentation, technical-writing, readme, api-docs]
- **Use Case**: Generate comprehensive technical documentation for code projects

## The Prompt

Create technical documentation for the project at `[PROJECT_PATH]`. 

**Project Type**: [web-app/cli-tool/library/api/script]

Generate:
1. README.md with project overview, installation, usage examples
2. Architecture overview (if applicable)
3. API documentation (if applicable)
4. Configuration guide
5. Troubleshooting section
6. Contributing guidelines (if open source)

Use clear headings, code examples with syntax highlighting, and follow markdown best practices.

## Context/Variables

- `[PROJECT_PATH]`: Path to project directory
- `[PROJECT_TYPE]`: Type of project being documented

## Expected Output

Complete markdown documentation files:
- README.md
- ARCHITECTURE.md (for complex projects)
- API.md (if applicable)
- TROUBLESHOOTING.md

## Notes

- Analyze code structure to generate accurate docs
- Include practical examples from actual code
- Consider target audience (developers, end-users)
- Add badges for build status, version, license if relevant

## Performance
- **Tested**: Y
- **Model**: Claude Sonnet 4.5
- **Success Rate**: 85%
- **Average Time**: 2-5 minutes for medium projects

## Revision History
- 2025-10-18: Initial creation
