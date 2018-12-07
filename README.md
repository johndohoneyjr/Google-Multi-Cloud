# Multi-Cloud Demo -- Google Cloud

This portion of the demo creates a VM on the Google Cloud under provisioning control of Terraform Enterprise (TFE).  This example illustrates the use of File and Remote Execution Provisioners.  This is used in conjunction with a Metadata Start-up Script that performs some basic installations (Python and Flask) as well as executing the Docker installation script that is uploaded by the file provisioner.

Important Note to remember, the file provisioners run first, then the imperatives for execution control in the Metadata Start-up Script

# Dependencies

Your Google Cloud environment MUST be defined as environment variables to work.  The following are examples:
```
GOOGLE_CREDENTIALS="Your Credential File.json
GOOGLE_REGION=us-central1
GOOGLE_ZONE=us-central1-c
GOOGLE_PROJECT=john-dohoney-test
```
On my computer, I create these on shell creation with them defined in my **.bashrc**

