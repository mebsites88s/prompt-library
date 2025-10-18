# CSV Data Analysis

## Metadata
- **Date Created**: 2025-10-18
- **Category**: coding
- **Topic Tags**: [python, pandas, csv, data-analysis, statistics]
- **Use Case**: Initial exploration and statistical analysis of CSV datasets

## The Prompt

Analyze the CSV file located at `[FILE_PATH]`. Provide a comprehensive analysis including:

1. Dataset overview (rows, columns, data types, memory usage)
2. Statistical summary for numerical columns (mean, median, std, quartiles)
3. Missing values analysis with percentages
4. Data quality assessment (duplicates, outliers, inconsistencies)
5. Column-specific insights (unique values for categorical, distributions for numerical)
6. Recommendations for data cleaning or further analysis
7. Suggested visualizations for key patterns

Use pandas for analysis. Include code snippets for any recommended follow-up analysis.

## Context/Variables

- `[FILE_PATH]`: Absolute Windows path to CSV file
  - Example: `C:\Users\aaron\Desktop\data.csv`

## Expected Output

Python script output including:
- DataFrame info summary
- Statistical tables
- Data quality metrics
- Specific observations about the dataset
- Actionable recommendations

## Notes

- Works best with datasets under 100MB for initial analysis
- For larger files, recommend chunking strategy
- Always use absolute paths on Windows
- Requires pandas, numpy installed in Python environment
- Can be combined with visualization prompts for deeper insights

## Performance
- **Tested**: Y
- **Model**: Claude Sonnet 4.5
- **Success Rate**: 95%
- **Average Time**: 30-60 seconds for datasets under 50MB

## Revision History
- 2025-10-18: Initial creation for PixelOni.ai library
