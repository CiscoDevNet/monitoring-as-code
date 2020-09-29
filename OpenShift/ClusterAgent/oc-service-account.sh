#!/bin/bash

oc create serviceaccount appd-agent
oc policy add-role-to-user view -z appd-agent
oc adm policy add-scc-to-user anyuid -z appd-agent
oc adm policy add-scc-to-user privileged -z appd-agent