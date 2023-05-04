variable "volume_size" {
  default = 8
}
variable "instance" {
  type    = list(any)
  default = ["Jenkins", "Ansible", "Controller"]
}