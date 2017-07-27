apiVersion: v1
kind: Service
metadata:
  name: escape-docs
spec:
  ports:
  - name: escape-docs-http
    port: 80
    targetPort: 80
    protocol: TCP
  selector:
    app: escape-docs

---

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: escape-docs
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: escape-docs
    spec:
      containers:
        - name: escape-docs
          image: {{{docker_image}}}
          ports:
            - containerPort: 80
