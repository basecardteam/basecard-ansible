# Makefile

# ENV 변수가 설정되지 않은 경우 기본값으로 "prod-node"를 사용합니다.
-include .env
ENV ?= prod-node
TERRAFORM_DIR := terraform/environments/$(ENV)
ANSIBLE_DIR := ./
ANSIBLE_VAULT_PASS_FILE := .vault_pass.txt
ANSIBLE_SECRETS_FILE    := playbooks/vars/secrets.yml

#############################################
############# Ansible Tasks  ################
#############################################

.PHONY: ap-setup-user

ap-setup-user:
	@echo "==> Ansible 플레이북 실행: playbooks/setup-user.yml..."
	@cd $(ANSIBLE_DIR) && \
	ansible-playbook playbooks/setup-user.yml --vault-password-file $(ANSIBLE_VAULT_PASS_FILE) $(ARGS)

ap-setup-basecard:
	@echo "==> Ansible 플레이북 실행: playbooks/setup-basecard.yml..."
	@cd $(ANSIBLE_DIR) && \
	ansible-playbook playbooks/setup-basecard.yml --vault-password-file $(ANSIBLE_VAULT_PASS_FILE) $(ARGS)

ap-setup-deploy-agent:
	@echo "==> Ansible 플레이북 실행: playbooks/setup-deploy-agent.yml..."
	@cd $(ANSIBLE_DIR) && \
	ansible-playbook playbooks/setup-deploy-agent.yml --vault-password-file $(ANSIBLE_VAULT_PASS_FILE) $(ARGS)


## Ansible: vault 비밀번호 파일을 생성합니다.
av-create-pass:
	@echo "==> Creating Ansible vault password..."
	@read -sp "🚨 INFO: Enter your vault password: " confirm && echo "$$confirm" > $(ANSIBLE_DIR)/$(ANSIBLE_VAULT_PASS_FILE)

## Ansible 암호화된 secrets.yml 파일을 수정합니다.
av-create-secrets:
	@echo "==> Encrypting secrets file..."
	@cd $(ANSIBLE_DIR) && \
	ansible-vault create $(ANSIBLE_SECRETS_FILE)

## Ansible: 암호화된 secrets.yml 파일을 열람합니다.
av-view:
	@echo "==> Viewing encrypted secrets file..."
	@cd $(ANSIBLE_DIR) && \
	ansible-vault view $(ANSIBLE_SECRETS_FILE) --vault-password-file $(ANSIBLE_VAULT_PASS_FILE)

## Ansible 암호화된 secrets.yml 파일을 수정합니다.
av-edit:
	@echo "==> Editing encrypted secrets file..."
	@cd $(ANSIBLE_DIR) && \
	ansible-vault edit $(ANSIBLE_SECRETS_FILE) --vault-password-file $(ANSIBLE_VAULT_PASS_FILE)