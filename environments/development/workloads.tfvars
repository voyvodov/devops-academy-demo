aws_region = "eu-central-1"
aws_profile = "tlrk"

workers= [
  {
    vpc_name= "academy1"
    count = 3
  }
]

key_pairs = {
  bastion = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcFSG6U1ohw92ldik7XMP/t0TY4lkFfaKT8rNh/NJ3fuf2xGH6wR/Lf9cyfH5PvCdPcyZDnY3Ez0ZFuVEKimRjpxWddhBWlBBIEf/v/A0uwUW8Ef4qIWdVrdf/iLlk/MdGnwo7UekZ6Lk2CeL9AZ9fm5e0OOezhUIC5sSlBOEAXD81rpQzLDf/0DfeConKMbdmDOFWEy4PZPSDtgwlBDxNfjTko46bBZhGuZ3Y0bdd648GEC1ML9E8luaX8f7Il7/thXl2le1jEOSH2aSqnUSPCNHOd20TfxFR+cN1SXFdV3Ctoxi032vxxrcpU4F0YTMCDxEN/HSfFDQhqDiCl+pr hvoyvodov@vmware.com"
  compute = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPncDYMqjLAjQzjIteoWaGmtjinw3gpdTWcbR0rXA6aT3uJebBz/VmhQdzZ4twfMEgcnwv/UBsRIG+aQE51Y0iQAPP0V1t5CVU2jiK/1l4dtlu4xP87NoqHCm4CR+7OVOziHEPmThG6e9/LnLki1atg4ibtDBmu/NUUlNNRn1F59mfLdeGFOm/tokhq7ytzjxehQjJG11w/TL4Y6H3Pij8Ghp6xApnNMdCuVZ4/xccoaD7ZlXONLzE3guuiWWDHqiz1XA9SWmXG6pov9vQEmAcE3bv0Xn2CFE3W8l5G2AXXDc64Xn/92Qj7WaB7mcq4XBD7CZDXaphg79wxfRLnKZV hvoyvodov@vmware.com"
}

