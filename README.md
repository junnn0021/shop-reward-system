## Team : 上남자들
 
손동훈 : [Sondoobo](https://github.com/Sondoobo) | 이준석 : [junnn0021](https://github.com/junnn0021) | 이인홍 : [Bleep-H3](https://github.com/Bleep-H3) | 현수빈 : [numberbeen](https://github.com/numberbeen) | 
 --- | --- | --- | --- |

 - Duration : 2022.03.07 ~ 2022.03.24
<br>

## Summary

충성 고객에 대한 데일리 출석 이벤트를 제공하여, 꾸준히 방문 인증을 하는 고객에 대해 리워드를 제공하는 것이 목표이다.
기존에 잘 운영되고 있던 쇼핑몰 사이트 위에 데일리 출석 이벤트를 위해 별도의 시스템을 구축하고자 한다.
시스템은 크게 사용자 인증 시스템, 출석 및 리워드 시스템으로 구분하여 시스템을 구축했다.

<br>

## Requirement

#### 출석 요구사항
- 출석 인증 요청, 구매 내역 확인 요청 발생 시 인증정보 확인은 필수입니다.
- 고객은 기본적으로 다음과 같은 활동을 할 수 있습니다.
  - 구매 내역을 조회할 수 있습니다.
  - 고객은 출석 이벤트와 관련하여 다음과 같은 활동을 할 수 있습니다.
  - 출석 인증을 할 수 있습니다.
  - 지난 며칠간 출석 인증을 했는지 여부를 조회할 수 있습니다.
  - 출석 인증 성공/실패 여부를 확인할 수 있습니다.
  - 수령 가능한 리워드가 무엇인지 조회할 수 있습니다.
  <br>
  
#### 리워드 요구사항
- 리워드 시스템 관리자는 다음과 같은 활동을 할 수 있습니다.
  - 고객의 출석 현황을 알아야 합니다.
  - 어떤 고객이 어떤 리워드를 받아가는지 알아야 합니다.
  - 리워드 항목의 수량을 조절할 수 있어야 합니다.
  - 리워드 재고가 특정 수치 이하로 떨어지면, 알림을 받아야 합니다.
  - 고객이 출석을 놓치지 않도록 푸시 알림을 제공할 수 있습니다.
<br>

#### 인프라 요구사항
- 사용자 인증 시스템과 리워드 시스템은 별개의 도메인으로 설계해야 합니다.
- 모든 서버는 컨테이너 환경 또는 서버리스로 구현되어야 합니다.
- 리워드 시스템 구현이 CI/CD에 의해 자동화되어야 합니다.
- IaC화가 진행되어야 합니다.

<br>

## Description

1. 인증 서비스

<img src="https://user-images.githubusercontent.com/119152428/228241164-d75ea248-9399-4e3c-bba5-c651d0f25727.png" width="800" height="350"/>

  - Cognito Userpool을 통해 사용자 인증을 진행합니다.
  - 고객의 이메일을 토대로 Shop DB에 저장된 고객의 구매내역을 확인합니다.
<br>

2. 출석 및 리워드 서비스

<img src="https://user-images.githubusercontent.com/119152428/228246761-9d24dac1-63c4-4ad7-8a6c-49e7d5d92790.png" width="800" height="600"/>

  - ECS를 통해 고객은 출석내역과 리워드 내역을 조회할 수 있습니다.
  - 재고가 일정 수준 이하로 떨어지면 관리팀에 알림 이메일을 전달합니다.
<br>

3. Client 푸쉬 알림

<img src="https://user-images.githubusercontent.com/119152428/228241636-8064a2cc-7c05-4bab-97ec-aaa7a8e7655b.png" width="600" height="300"/>

 - 당일 출석하지 않은 고객에 대해서만 마케팅 푸쉬 알림 이메일을 전송합니다.
<br>

4. 재고 관리 서비스

<img src="https://user-images.githubusercontent.com/119152428/228241549-a63fc99f-d8ed-4d07-a418-d4032522b354.png" width="500" height="300"/>

 - 수동으로 리워드 상품의 재고를 변경할 수 있습니다.
 - 지금까지 특정 고객이 수령한 상품 모두를 조회할 수 있습니다.
<br>

## Architecture
<img src="https://user-images.githubusercontent.com/119108967/228255931-00d1c93c-480e-45f7-9445-9baeae57a3e5.png" width="1000" height="800"/>
<img src="https://user-images.githubusercontent.com/119108967/228256085-ae1d6e6d-219b-4b1c-9c1e-0674e83fd12b.png" width="1000" height="700"/>

 - 인증 Lambda : 인증 서비스는 고객의 정보를 확인하고 일치여부를 판단해 리턴하는 작은 기능 단위로 구성되므로 함수 단위의 컴퓨팅 리소스인 람다를 사용했습니다.
 - ECS : 출석에 대한 기능과 리워드에 대한 기능을 모두 수행하는 메인 서버이기에 Lambda보다는 큰 규모의 컨테이너 단위로 구성하기 위해 ECS를 사용하였습니다.
 - VPC endpoint(Interface) : NAT Gateway를 통해 아웃바운드되는 data의 양을 감소시키므로써 보다 비용 효율적인 서비스 구성을 위해 구성하였습니다.
 - Secrets Manager : 애플리케이션 단위에서 DB에 접근할 수 있는 비밀번호를 소유하지 못하도록 Secrets Manager를 통해 참조형으로 구성하였습니다.
 - 아키텍처 구현 과정 : [Notion](https://www.notion.so/Final-Project-Team-D-b8582dc562104aa2a11de017e9087d23)
 
<br>

## Environment
<img src="https://img.shields.io/badge/AWS-232F3E?stylefor-the-badge&logo=Amazon AWS&logoColor=FAFAFA"/> <img src="https://img.shields.io/badge/Docker-2496ED?stylefor-the-badge&logo=Docker&logoColor=FAFAFA"/>
<img src="https://img.shields.io/badge/Fastify-000000?stylefor-the-badge&logo=Fastify&logoColor=FAFAFA"/>
<img src="https://img.shields.io/badge/GitHub Actions-2088FF?stylefor-the-badge&logo=GitHub Actions&logoColor=FAFAFA"/>
<img src="https://img.shields.io/badge/Grafana-F46800?stylefor-the-badge&logo=Grafana&logoColor=FAFAFA"/>
 <img src="https://img.shields.io/badge/MySQL-4479A1?style=stylefor-the-badge&logo=MySQL&logoColor=FAFAFA"/>
<img src="https://img.shields.io/badge/Node.js-339933?stylefor-the-badge&logo=Node.js&logoColor=FAFAFA"/>
<img src="https://img.shields.io/badge/Serverless-FD5750?stylefor-the-badge&logo=Serverless&logoColor=FAFAFA"/>
<img src="https://img.shields.io/badge/Terraform-844FBA?stylefor-the-badge&logo=Terraform&logoColor=FAFAFA"/>

 <br>

## Prerequisites
AWS 배포 자동화를 구현하기 위해서는 AWS에 계정이 있어야 합니다.
```
https://aws.amazon.com/ko/
``` 
인증 서비스의 AWS 인프라를 구축 하기 위해 IaC_production/user-auth 폴더에서 다음을 실행합니다.
```
terraform init
terraform plan
terraform apply
```
출석 및 리워드 서비스의 AWS 인프라를 구축 하기 위해 IaC_production/attendance 폴더에서 다음을 실행합니다.
```
terraform init
terraform plan
terraform apply
```
데이터베이스에 값을 넣기 위해서는 shoppingmall-db 폴더에서 다음을 실행합니다.
```
mysql -h [데이터베이스 엔드포인트] -u [데이터베이스 사용자명] -P 3306 -p [데이터베이스 사용자 비밀번호]
create database shop
use shop
source init.sql
```
<br>

## Example of use
#### 인증 서비스
1. 가입된 이메일이 아닐 경우

<img src="https://user-images.githubusercontent.com/119108967/228247936-30d31051-5461-4aeb-9be4-001ac0c5e9d6.png" width="400" height="30"/>

2. 가입은 되어있지만 구매 내역이 없을 경우

<img src="https://user-images.githubusercontent.com/119108967/228248042-4726baad-72ed-4551-b73b-a1edb483d695.png" width="400" height="30"/>

3. 모든 인증 과정에 성공했을 경우

<img src="https://user-images.githubusercontent.com/119108967/228248061-d9045e95-2d9e-46fa-9d62-3a6d46151c26.png" width="400" height="30"/>

<br>

#### 출석 및 리워드 서비스
1. 사용자가 출석을 할 경우

<img src="https://user-images.githubusercontent.com/119108967/228248199-14eaf3a6-a215-4563-b418-af8e5338beac.png" width="400" height="30"/>

2. 사용자가 이미 출석을 한 경우

<img src="https://user-images.githubusercontent.com/119108967/228248208-be5ad5b5-e914-487d-8ba2-86731b5b49b9.png" width="400" height="30"/>

3. 자신의 출석일수, 현재 보상, 다음 보상을 알고 싶을 경우

<img src="https://user-images.githubusercontent.com/119108967/228248234-1bf4bdb6-ef2b-4d7d-8c8b-91049ca2a0c7.png" width="400" height="60"/>

4. 출석일수에 따라 어떤 보상이 있는 지 알고 싶을 경우

<img src="https://user-images.githubusercontent.com/119108967/228248252-f2b34efd-f07b-44d5-992d-f44cff7380ad.png" width="200" height="80"/>

