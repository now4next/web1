#!/usr/bin/env python3
import csv
import sys

def escape_sql(text):
    """Escape single quotes for SQL"""
    if text is None:
        return ''
    return text.replace("'", "''")

def main():
    csv_file = 'Competency_Evaluation_Table_2.csv'
    
    print("-- Update job_name for competencies from CSV data")
    print()
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        competency_jobs = {}  # {역량명: 직무명}
        
        for row in reader:
            job_name = row['직무명'].strip()
            competency_name = row['역량명'].strip()
            
            # Store job name for each competency
            if competency_name:
                competency_jobs[competency_name] = job_name
        
        # Generate UPDATE statements
        for competency_name, job_name in competency_jobs.items():
            escaped_competency = escape_sql(competency_name)
            escaped_job = escape_sql(job_name)
            
            print(f"UPDATE competencies SET job_name = '{escaped_job}' WHERE keyword = '{escaped_competency}' AND job_name IS NULL;")
    
    print()
    print(f"-- Total: {len(competency_jobs)} competencies updated with job names")

if __name__ == '__main__':
    main()
