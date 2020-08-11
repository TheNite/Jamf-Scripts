#!/bin/bash

kubectl config use-context gke_tapad-infrastructure-prd_us-central1_infra-us-central1-081b
kubectl config current-context
kubectl exec -it atlantis-0 -- /bin/bash
sleep 3
cd /atlantis-data/repos/Tapad/terraform/890/default/pagerduty

/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"adrian_f\"] P7O114L
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"alexey_a\"] PD3TANV
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"alireza_s\"] PY6PP98
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"anthony_f\"] PC3QT4V
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"ben_r\"] P3J9769
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"bobby_v\"] PYGN0KV
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"daniel_t\"] PGOCBGF
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"davide_r\"] PWN6ZGZ
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"derek_f\"] PKFKYMA
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"diego_s\"] PSI4JZ9
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"edward_w\"] PTCPW78
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"eli_t\"] P70OYTN
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"elias_j\"] P23KRH4
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"garrett_h\"] P0LYRYE
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"guillaume_p\"] PD9HYV5
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"ian_w\"] PHPBSRR
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"ingar_a\"] PCGRA9P
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"jason_s\"] P9LI4JR
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"jeff_o\"] P3N8T6K
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"jeff_r\"] P3M8SSM
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"jose_s\"] P4RB5VD
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"jostein_g\"] PNUCNE6
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"knut_s\"] PDGDLVU
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"li_q\"] P1I73ML
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"lisa_m\"] P21S9A6
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"marvin_m\"] PLYERM2
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"michael_c\"] PN87PR6
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"michael_d\"] P1EMYVT
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"michelle_l\"] PUG1NJF
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"mucahit_k\"] PFVC4OA
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"nianzu_t\"] PKX1YMT
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"oleksii_i\"] PRB8AFK
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"paul\"] P8TN5TG
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"pawel_c\"] PJ2R4Y8
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"philip_t\"] PPKKYOH
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"preethi_c\"] POOHIM8
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"samantha_l\"] PT3O0AR
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"samuel_b\"] PATF8CN
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"stig_h\"] PIHBWJE
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"taylor\"] P7AZLXS
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"tom_c\"] PZC4WIQ
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"torkjel_h\"] P7QJXZV
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"vahan_a\"] P4YWO95
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"viktor_g\"] PHQIRRL
/atlantis-data/bin/terraform0.12.6 import pagerduty_user.all_users[\"yiming_l\"] PQLP5TG




































/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"Activation\"] P6WZ7X3
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"Alert_test\"] PQ5RDRE
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"CX\"] PEY5521
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"DataIngress\"] PTGNASJ
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"DataPlat_Oslo\"] PDU3GNZ
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"DataScienceTool\"] PAJJND8
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"DeviceGraph\"] PYNK1KK
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"DGA\"] PJ5H420
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"DSP\"] P52MK01
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"ETL\"] P1JG5EP
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"ETL_Oslo\"] PKVY2XB
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"Infra_Hardware\"] PW9AVS7
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"Infra_team\"] PVF5WSY
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"Ingress_cross\"] PA78NRQ
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"Insights\"] PYCLR2J
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"slack\"] PN88JG2
/atlantis-data/bin/terraform0.12.6 import pagerduty_team.all_teams[\"PaaS\"] PEOOAPY


