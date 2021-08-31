---
title: "Lab Developer Roles"
description: "This guide covers which roles enable lab developers to utilize certain features."
isPublished: true
---

# Lab Developer Roles

When developing labs on Lab On Demand (LOD), various development functions will require different permissions. If you are an Organization Administrator, this guide will cover which roles are needed for lab developers to utilize certain features. 

## Philosophy

The Organization Lab Developer role set on LOD uses an additive model where common functions are enabled by **Base Roles**, and additional functionality is given via **Supplemental Roles**. This allows for modular customization of permissions for an Organization while giving developers the specific permissions needed for their workflow. 

  * [Roles](#roles)
    + [Organization Role Admin](#organization-role-admin)
  * [Base Roles](#base-roles)
    + [Default User](#default-user)
    + [Organization Lab Developer](#organization-lab-developer)
    + [Organization Lab Report Viewer](#organization-lab-report-viewer)
  * [Supplemental Roles](#supplemental-roles)
    + [Organization Activity Editor](#organization-activity-editor)
    + [Organization Advertising Editor](#organization-advertising-editor)
    + [Organization Bug Report Manager](#organization-bug-report-manager)
    + [Organization Evaluation Control](#organization-evaluation-control)
    + [Organization Evaluation Viewer](#organization-evaluation-viewer)
    + [Organization Lab Instance Monitor](#organization-lab-instance-monitor)
    + [Organization Lab Instance Report Viewer](#organization-lab-instance-report-viewer)
    + [Organization Lab Launcher](#organization-lab-launcher)
    + [Organization Lab Profile Viewer](#organization-lab-profile-viewer)
    + [Organization Template Gallery Management](#organization-template-gallery-management)
    + [Organization Theme Management](#organization-theme-management)
    + [Organization VM Profile Viewer](#organization-vm-profile-viewer)
  * [Organization Management](#organization-management)

## Roles
This section defines the roles available to lab developers.

### Organization Role Admin

This role grants no developer permissions, but grants the ability to assign other Lab Developer Roles to users in their Organization. This role is reserved for Organization Administrators and provides the opportunity for self-service permission managemnent.

**Organization Role Admins** can assign the following roles:

**Base Roles**  
[Default User](#default-user)  
[Organization Lab Developer](#organization-lab-developer)  
[Organization Lab Report Viewer](#organization-lab-report-viewer)  

**Supplemental Roles**  
[Organization Activity Editor](#organization-activity-editor)  
[Organization Advertising Editor](#organization-advertising-editor)  
[Organization Bug Report Manager](#organization-bug-report-manager)  
[Organization Evaluation Control](#organization-evaluation-control)  
[Organization Evaluation Viewer](#organization-evaluation-viewer)  
[Organization Lab Instance Monitor](#organization-lab-instance-monitor)  
[Organization Lab Instance Report Viewer](#organization-lab-instance-report-viewer)  
[Organization Lab Launcher](#organization-lab-launcher)  
[Organization Lab Profile Viewer](#organization-lab-profile-viewer)  
[Organization Template Gallery Management](#organization-template-gallery-management)  
[Organization Theme Management](#organization-template-gallery-management)  
[Organization VM Profile Viewer](#organization-vm-profile-viewer)

The permissions that come with these roles are outlined below.

## Base Roles

### Default User
This role is required for a user to login to Lab On Demand. It will be added by default to any user created by the **Organization Role Admin**.

### Organization Lab Developer
This role is the base role for lab development. It grants access to most lab development fuctions.

**Organization Lab Developers** have the ability to access and manage the following LOD features:  

- [Access Control Lists](https://docs.learnondemandsystems.com/lod/access-control-lists.md)
- [Container Images](https://docs.learnondemandsystems.com/lod/container-images.md)
- [Container Registries](https://docs.learnondemandsystems.com/lod/container-registries.md)
- Storage
- [Exam Scoring](https://docs.learnondemandsystems.com/lod/pbt/overview.md)
- Developer Files
- Launching Labs
- Lab Instructions
- [Lab Profiles](https://docs.learnondemandsystems.com/lod/feature-focus/lab-profiles/create.md)
- [Lab Series](https://docs.learnondemandsystems.com/lod/lab-series.md)
- Lab Tags
- [Removable Media](https://docs.learnondemandsystems.com/lod/create-removable-media.md)
- [Themes](https://docs.learnondemandsystems.com/lod/lod-themes.md)
- [Virtual Machine Profiles](https://docs.learnondemandsystems.com/lod/vm-profiles.md)

### Organization Lab Report Viewer
This is a view-only role is intended for collecting data and viewing reports on lab activity within an Organization. **Organization Lab Report Viewers** can view the following:
- [API](https://docs.learnondemandsystems.com/lod/lod-api/lod-api-main.md) errors
- Lab Instances
- [Lab Profiles](https://docs.learnondemandsystems.com/lod/feature-focus/lab-profiles/create.md)
- Lab Profile statistics
- [Lab Series](https://docs.learnondemandsystems.com/lod/lab-series.md)
- Users

**Note**: This role also grants the ability to launch labs. 

## Supplemental Roles
Supplemental Roles are intented to be added in addition to Base Roles. They can be assigned alone, but this can result in missing dependent permissions.

### Organization Activity Editor
Grants the ability to manage lab activities. These permissions are included in [Organization Lab Developer](#organization-lab-developer). 

### Organization Advertising Editor
Grants the ability to manage Advertising Campaigns. 

### Organization Bug Report Manager
Grants the ability to manage Bug Reports.

### Organization Evaluation Control
Grants the ability to manage post-lab Evalutations and view responses.

### Organization Evaluation Viewer
Grants the ability to view Evaluations and their responses. These permissions are included in [Organization Evaluation Control](#organization-evaluation-control).

### Organization Lab Instance Monitor
Grants the ability to Monitor Instances and view users. 

### Organization Lab Instance Report Viewer
Grants the viewing permissions required to pull reports on Lab Instances.

### Organization Lab Launcher
Grants the ability to view and launch labs. These permissions are included in [Organization Lab Developer](#organization-lab-developer). 

### Organization Lab Profile Viewer
Grants the ability to view Lab Profiles and Lab Series. These permissions are included in [Organization Lab Developer](#organization-lab-developer), [Organization Lab Launcher](#organization-lab-launcher), and [Organization Lab Instance Report Viewer](#organization-lab-instance-report-viewer).

### Organization Template Gallery Management
Grants the ability to publish Lab Profiles to the Organization [Template Gallery](https://docs.learnondemandsystems.com/lod/template-gallery.md), and grants Lab Tag management. 

### Organization Theme Management
Grants the ability to manage [Themes](https://docs.learnondemandsystems.com/lod/lod-themes.md). These permissions are included in [Organization Lab Developer](#organization-lab-developer).

### Organization VM Profile Viewer
Grants the ability to view [VM Profiles](https://docs.learnondemandsystems.com/lod/vm-profiles.md). These permissions are included in [Organization Lab Developer](#organization-lab-developer).

## Organization Management

Organization Management defines permission scope. When adding an Organization to a user's Organization Management, their current roles will apply to everything within that Organization **and** its child Organizations.

> A proper Organizational structure on LOD is key to managing user access. 

To change a user's Organization Management:  
1. Go to the user's profile.
2. Select **Edit**.
3. Select the **Managed Organizations** tab.
4. Select **+ Add Organization**.
5. An Organization search will pop up. Enter desired filters and select **Search**. 
6. Check the desired Organization(s) from the list and select **OK**.
7. Apply the changes to the user by selecting **Save**.

[Back to top](#lab-developer-roles)