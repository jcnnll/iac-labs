# IaC-lab: Research & Experimentation

Personal workbench for testing local Infrastructure-as-Code (IaC) patterns. 

## Tools:

- Terraform handles infrastructure provisioning
- Ansible handles machine state management
- Lima handles individual VM instance life-cycle management

## Purpose:

This is a place for learning and experimentation where one of the main experiments being run against this repo is implementing automated static code anaylis and security scans for IaC code bases.

## CI Process

For local linting and static code analysis the `scripts/pre-commit.sh` can be run to lint, validate an run security scans on the Terraform codebase and Ansible-Lint on the Ansible codebase.

The GitHub Actions pipeline defined for the project will run all the static code analysis and security scans when changes are committed to the repository.
