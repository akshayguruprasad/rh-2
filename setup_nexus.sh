#!/bin/bash
oc new-app sonarcube docker.io/sonatype/nexus3:latest
 oc expose svc nexus3
 oc rollout pause dc nexus3
 oc patch dc nexus3 -p="{"spec":{"strategy":{"type":"Recreate"}}}"
  oc set resources dc nexus3 --requests="cpu=100m,memory=256Mi" --limits="cpu=100m,memory=256Mi"
  
  
  
    echo "apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: nexus-pvc
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 4Gi" | oc create -f -
  
  oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc

  oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
  oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://$(oc get route nexus3 --template='{{ .spec.host }}'):8081/
  
  oc rollout resume dc nexus3
  
    http://$(oc get route nexus3 --template='{{ .spec.host }}')
  chmod +x setup_nexus3.sh
  ./setup_nexus3.sh admin admin123 http://$(oc get route nexus3 --template='{{ .spec.host }}')
  rm setup_nexus3.sh
   oc expose dc nexus3 --port=5000 --name=nexus-registry
   oc create route edge nexus-registry --service=nexus-registry --port=5000
   
   oc annotate route nexus3 console.alpha.openshift.io/overview-app-route=true
   oc annotate route nexus3 console.alpha.openshift.io/overview-app-route=true
