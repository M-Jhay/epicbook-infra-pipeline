# EpicBook Capstone Project Infrastructure

## 📖 Overview
EpicBook is a two‑tier application consisting of:
- **Frontend/Application Tier**: Deployed on a Linux VM with Nginx.
- **Backend Tier**: MySQL Flexible Server hosted on Azure.

This repository contains the Terraform infrastructure pipeline for the EpicBook Capstone project. It is designed to provision and manage cloud resources in Azure using Azure DevOps pipelines.

The pipeline is defined in a YAML file and automates the following:

- System preparation on the build agent (installing unzip, curl, etc.).
- Terraform installation.
- Terraform backend initialization using Azure Storage for state management.
- Variable injection (database credentials, SSH keys).
- Terraform plan to preview infrastructure changes.
- Terraform apply to provision the infrastructure.

---

## What This Repo Contains
- Terraform configuration files (main.tf, variables, outputs).
- Azure DevOps pipeline YAML (azure-pipelines.yml) that automates provisioning.
- Variable groups and secure files integration for secrets and SSH keys.

---

## What This Repo Does NOT Contain
Ansible playbooks or configuration management scripts.

Ansible is part of the broader project but is not included in this infrastructure repository. This repo is strictly for provisioning infrastructure with Terraform and Azure DevOps.

---

## 🏗️ Infrastructure
Terraform provisions:
- Resource Group
- Virtual Network, Subnet, and Network Security Group
- Public IP and Network Interface
- Ubuntu VM (application tier)
- MySQL Flexible Server + Database (backend tier)
- Storage Account + Blob Container (for remote Terraform state)

---

## How to Use
1. Import this repository into Azure DevOps.
2. Create a pipeline and paste the provided YAML file.
3. Ensure the following are set up:
   - Azure service connection (capstone-service-connection).
   - Variable group (Db-secrets).
   - Secure files for SSH keys (ReactAppKey, ReactAppKey.pub).
   - Azure Storage account and container for Terraform state.
4. Run the pipeline to provision the infrastructure.

---

## 📂 Repository Structure
epicbookCapstoneProject/
├── main.tf              # Core Terraform configuration
├── variables.tf         # Input variables
├── output.tf            # Terraform outputs
├── epicbook-infra.yml   # Azure Pipeline YAML definition         
└── README.md            # Project documentation

---

## 📌 Notes
Do not commit sensitive files (terraform.tfstate, .pem, .key). Use .gitignore.

Terraform state is stored remotely in Azure Blob Storage.

---

## 👩‍💻 Author
Project maintained by **Jecinta Elugwu** as part of the Azure Devops Capstone Project.

