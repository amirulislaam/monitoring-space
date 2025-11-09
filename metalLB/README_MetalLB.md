# 🛠️ Step 1: Install MetalLB

Apply the official manifests:

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml


This creates the `metallb-system` namespace and deploys the controller + speaker pods.


# 🛠️ Step 2: Configure MetalLB with your LAN IP pool

Since your node is `192.168.1.100`, we’ll assign MetalLB a pool that includes `192.168.1.150`. Make sure `.150` is **not used by DHCP** or another device.

Create a file `metallb-config.yaml` and Apply it:

kubectl apply -f metallb-config.yaml

# 🛠️ Step 3: Patch ingress-nginx service

Your ingress controller service is currently `LoadBalancer` with `<pending>`. MetalLB will now assign it `192.168.1.150`.

Check:

kubectl get svc -n ingress-nginx

You should see:

NAME                       TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)
ingress-nginx-controller   LoadBalancer   10.111.8.61    192.168.1.150   80:31012/TCP,443:30255/TCP

# 🛠️ Step 4: Update DNS or /etc/hosts

Point your domains to `192.168.1.150`:

Edit `/etc/hosts` on your client machine(s):

192.168.1.150   grafana.observabilitystack.run.place
192.168.1.150   prometheus.observabilitystack.run.place
192.168.1.150   alertmanager.observabilitystack.run.place

Or, better, create DNS A records for those hostnames pointing to `192.168.1.150`.

# 🛠️ Step 5: Verify

1. Check ingress objects:
   kubectl get ingress -n server-monitoring
   You should see hosts and TLS secrets.
2. Test with curl:
   curl -vk https://grafana.observabilitystack.run.place
   curl -vk https://prometheus.observabilitystack.run.place
   curl -vk https://alertmanager.observabilitystack.run.place
3. Open in browser — you should see Grafana, Prometheus, and Alertmanager UIs with your CA‑signed cert.

# ✅ Summary
- **MetalLB** advertises `192.168.1.150` on your LAN.  
- **Ingress-nginx** now has a real EXTERNAL-IP.  
- **DNS/hosts** point your domains to `192.168.1.150`.  
- You get clean HTTPS access on port 443, no NodePort or iptables hacks.  
- Adding a worker node later will still work — MetalLB will load-balance traffic across nodes running ingress-nginx pods.  


👉 Do you want me to also give you a **ready-to-apply Ingress manifest** for Grafana/Prometheus/Alertmanager (instead of only Helm values), so you can double‑check that the routing is correct once MetalLB assigns the IP?