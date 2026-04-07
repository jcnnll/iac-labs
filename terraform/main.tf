
resource "local_file" "config" {
  # Use single $ to resolve the path and render the template
  filename = "${path.module}/.dns.yaml"
  content = templatefile("${path.module}/vm_base.tftpl", {
    image_url   = var.dns_vm.image_url
    socket_path = "/tmp/vlab_vmnet"
    static_ip   = var.dns_vm.static_ip
    hostname    = var.dns_vm.hostname
    cpus        = var.dns_vm.cpus
    memory      = var.dns_vm.memory
    disk        = var.dns_vm.disk
    script      = <<-EOT
                    # 1. Set Identity
                    hostnamectl set-hostname ${var.dns_vm.hostname}
                    echo "${var.dns_vm.static_ip} ${var.dns_vm.hostname}" >> /etc/hosts

                    # 2. Bootstrap networking (Phase 1 logic)
                    cat > /etc/netplan/50-static-dns.yaml <<'EOF'
                    network:
                      version: 2
                      ethernets:
                        eth0:
                          addresses:
                            - ${var.dns_vm.static_ip}/24
                          nameservers:
                            addresses: [8.8.8.8]
                    EOF
                    netplan apply

                    # 3. Force DNS for immediate package/ansible readiness
                    rm -f /etc/resolv.conf
                    echo "nameserver 8.8.8.8" > /etc/resolv.conf
                  EOT
  })
}

resource "null_resource" "dns" {
  depends_on = [local_file.config]

  provisioner "local-exec" {
    command = "limactl create --name=dns ${local_file.config.filename} && limactl start dns"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "limactl stop dns && limactl delete dns"
  }
}

