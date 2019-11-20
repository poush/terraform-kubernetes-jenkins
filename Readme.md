apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-data
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: gp2
