from github import Github
import csv

# GitHub Auth
token = '' # Github Access Token
gh = Github(token)

# Setting up Variables
csv_file = 'githubAduit.csv'
dict = {}

# Repos to Audit
audit_repo = []

for repo in gh.get_user().get_repos():
    if repo.name in audit_repo:
        dict[repo.name] = []
        # print(repo.name)
        for collaborators in gh.get_repo(repo.id).get_collaborators():
            dict[repo.name].append(collaborators.login)

with open(csv_file, "w") as f:
    writer = csv.writer(f)
    writer.writerow(['Repo', 'Members'])
    for key, value in dict.items():
        writer.writerow([f'{key}', f'{value}'])
