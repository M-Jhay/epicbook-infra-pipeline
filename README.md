# EpicBook Capstone Project Infrastructure

## 📖 Overview
EpicBook is a two‑tier application consisting of:
- **Frontend/Application Tier**: Deployed on a Linux VM with Nginx.
- **Backend Tier**: MySQL Flexible Server hosted on Azure.

This repository contains the **Infrastructure as Code (IaC)** and **configuration management** needed to provision and deploy EpicBook using:
- **Terraform** (for infrastructure provisioning)
- **Ansible** (for VM configuration and application deployment)
- **Azure Pipelines** (for CI/CD automation)

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

## ⚙️ Configuration
Ansible configures the VM by:
- Updating and installing required packages
- Installing and configuring Nginx
- Deploying the EpicBook application code
- Setting environment variables for database connectivity

Inventory and variable files are updated automatically using **Terraform outputs**.

---

## 🚀 Pipeline Workflow
Azure Pipelines automates:
1. **Terraform Stage**
   - Install Terraform
   - Initialize backend (Azure Blob for state)
   - Run `terraform plan` and `terraform apply`
2. **Ansible Stage**
   - Install Ansible
   - Download SSH keys from Secure Files
   - Update inventory with Terraform outputs
   - Run playbooks to configure VM and deploy EpicBook
3. **Verification Stage**
   - Confirm Nginx is running
   - Validate EpicBook application is accessible

---

## 📂 Repository Structure
epicbookCapstoneProject/
├── main.tf              # Core Terraform configuration
├── variables.tf         # Input variables
├── terraform.tfvars     # Variable values
├── output.tf            # Terraform outputs
├── epicbook-infra.yml   # Azure Pipeline YAML definition
├── ansible/
│   ├── inventory.ini    # Ansible inventory template
│   ├── playbooks/       # Playbooks for setup, nginx, app deployment
│   └── roles/           # Roles for modular configuration
└── README.md            # Project documentation

---

## 🔑 Prerequisites
- Azure subscription
- GitHub repository connected to Azure Pipelines
- SSH key pair stored in Secure Files
- Terraform and Ansible installed in pipeline agents

---

## 📌 Notes
Do not commit sensitive files (terraform.tfstate, .pem, .key). Use .gitignore.

Terraform state is stored remotely in Azure Blob Storage.

Ansible inventory is updated dynamically with Terraform outputs.

## 👩‍💻 Author
Project maintained by **Jecinta Elugwu** as part of the Azure Devops Capstone Project.

