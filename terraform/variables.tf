variable "dns_vm" {
  description = "Configuration for the DNS virtual machine"
  type = object({
    hostname  = string
    static_ip = string
    disk      = string
    memory    = string
    cpus      = number
    image_url = string
  })
  default = {
    hostname  = "dns"
    static_ip = "192.168.2.10"
    disk      = "20GiB"
    memory    = "512MiB"
    cpus      = 1
    image_url = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-arm64.img"
  }
}
