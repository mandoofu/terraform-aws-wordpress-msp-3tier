# Terraform AWS WordPress MSP 3-Tier Architecture

## 📌 Overview

이 프로젝트는 **MSP 실무 환경을 기준으로 설계된 AWS 기반 3-Tier WordPress 아키텍처**입니다.  
또한 GitLab + GitLab Runner 기반의 CI/CD 운영 환경을 포함하여  
실제 서비스 운영에 필요한 **Service VPC + Tools VPC + VPC Peering 구조**로 구성되어 있습니다.

이 레포는 포트폴리오 및 실무 참고용으로 작성되었으며,  
Terraform 기반의 멀티모듈 구조, GitLab 운영 환경, WordPress ASG 자동 확장 구조 등을 포함합니다.

---

## 🏛️ Architecture

### ✔ Core components

- **Service VPC**
  - ALB (Application Load Balancer)
  - ASG + Launch Template (WordPress EC2)
  - RDS MySQL
  - EFS (WordPress 공유 스토리지)
  - NAT Gateway & Private Subnets
  - CloudWatch Logs

- **Tools VPC**
  - GitLab Server
  - GitLab Runner (Docker executor)
  - Peering to Service VPC

- **IaC**
  - Terraform (AWS provider)
  - Remote backend (S3 + DynamoDB)

---

## 🚀 Deployment Order

1. **bootstrap_backend**  
   S3 버킷 + DynamoDB 테이블 생성

2. **envs/service**  
   - VPC  
   - ALB  
   - ASG + Launch Template  
   - EFS  
   - RDS  
   - Security groups

3. **envs/tools_and_peering**  
   - GitLab Server  
   - GitLab Runner  
   - Tools VPC  
   - VPC Peering

---

## 🔐 Security Notes

- `terraform.tfvars` 는 **절대 Git에 올리지 않습니다.**
- 이 레포에는 `.example` 파일만 포함되어 있으며 실 운영 값은 포함되지 않습니다.
- 모든 민감 정보는 Secret Manager 또는 CI/CD Variable 로 관리해야 합니다.
- security group 기본값 중 `0.0.0.0/0`는 **예시 용도**이며 반드시 수정해야 합니다.

---

## 🛠 Requirements

- Terraform >= 1.6.0
- AWS CLI
- GitLab Runner (optional)
- Remote backend (S3 + DynamoDB)

---

## 📌 Future Extensions

- GCP GKE 기반 GitLab Runner 확장
- OpenAPI 기반 API Tier 추가
- AWS ↔ GCP 멀티클라우드 구조 확장
- Blue-Green 배포 자동화

---

## 📄 License
MIT License
