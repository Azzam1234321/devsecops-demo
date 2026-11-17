# DevSecOps Automated Security Pipeline Demo 🛡️🚀

![Security Pipeline Status](https://github.com/Azzam1234321/devsecops-demo/actions/workflows/sec.yml/badge.svg)

## 📌 Project Overview
This repository demonstrates a practical **Shift-Left DevSecOps CI/CD Pipeline** using GitHub Actions. The pipeline acts as an automated security gate that scans both Infrastructure as Code (IaC) and container images upon every push, intentionally failing the build if misconfigurations or high/critical vulnerabilities are detected.

## 🛠️ Tech Stack & Security Tools
* **CI/CD:** GitHub Actions
* **IaC & Scanning:** Terraform (AWS S3 & KMS) scanned via **Checkov**
* **Containerization & Scanning:** Docker (Python HTTP Server) scanned via **Trivy**

## 🔍 Security Remediation Journey (Fail-to-Pass)
The Actions history in this repository intentionally preserves the iterative troubleshooting and remediation workflow:

1. **IaC Misconfiguration Detection (Checkov):**
   * *Initial State:* The pipeline blocked an insecure AWS S3 configuration (`main.tf`) that permitted public ACLs/policies and lacked encryption, versioning, and lifecycle rules.
   * *Remediation:* Enforced `aws_s3_bucket_public_access_block`, enabled bucket versioning, configured default SSE-KMS encryption with key rotation, added lifecycle rules for incomplete multipart uploads, and documented architectural risk-acceptance suppressions (`checkov:skip`).

2. **Container Vulnerability Management & Hardening (Trivy):**
   * *Initial State:* Scanning the initial `python:3.11-slim` (Debian-based) image triggered a build failure due to 48 OS-level vulnerabilities and vulnerable Python packaging dependencies.
   * *Remediation (Attack Surface Reduction):* Migrated the base image to `python:3.11-alpine`, eliminating the OS-level vulnerabilities.
   * *Zero-Vulnerability Image:* Resolved the remaining high-severity vulnerability (`CVE-2025-47273` in `setuptools`) by stripping unneeded package managers (`pip`, `setuptools`, and `ensurepip`) from the runtime image and running the container under a non-root user (`appuser`).

## 📂 Repository Structure
```text
├── .github/workflows/
│   └── sec.yml        # CI/CD pipeline definition (Checkov + Trivy)
├── Dockerfile         # Hardened Alpine-based non-root container image
├── app.py             # Lightweight Python HTTP application
└── main.tf            # Hardened Terraform AWS S3 & KMS configuration
