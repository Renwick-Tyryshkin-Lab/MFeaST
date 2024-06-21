# Molecular-Feature-Selection-Tool (MFeaST)
Ensemble machine learning approach for feature selection. 

If you choose to download _MFeaST_ from github, please select the file for your system: 

.dmg or .app files are for Mac installation. 

.exe files are for Windows installation. 

MATLAB Runtime 2023a required for MATLAB user version of latest release. Please use the "Installer Version" to install Runtime with MFeaST. 

See [renwicklab](https://www.renwicklab.com/molecular-feast/)https://www.renwicklab.com/molecular-feast/ for more information. 
For step by step instructions on installation and use, please see "Before You Begin" and "Stage 3" in [A user-driven machine learning approach for RNA-based sample discrimination and hierarchical classification
](https://star-protocols.cell.com/protocols/3074#summary) 

If issues, please write in Issues or contact either Tashifa Imtiaz (17ti6@queensu.ca) or Kathrin Tyryshkin (kt40@queensu.ca)

## Table of Contents
* [Download and install _MFeaST_](#setup)
* [Errors during _MFeaST_ installation](#troubleshooting)

## If you choose to download and install _MFeaST_ from: [https://www.renwicklab.com/molecular-feast/](https://www.renwicklab.com/molecular-feast/).<a name="setup"></a>
1. Choose the one-step installation version. This ensures the MATLAB Runtime corresponding to the app version is also installed.    
2. Select your operating system and then click the “Add to cart” button. Click “View cart”.  
3. Click “Proceed to checkout”. Type in your contact information as requested and click “Submit”.  
4. Click the “Download” button.  
5. A pop-up will appear. Type in the username: mfeast, password: rankmolecules.  
6. Install _MFeaST_ as an “Administrator”. See [Errors during _MFeaST_ installation](#troubleshooting) for errors during installation and Mac OS specific installation instructions.

   **Note:** If you already have MATLAB installed, the one-step installation version of _MFeaST_ is still recommended. This version will install the MATLAB Runtime corresponding to the app, which may be different from your installed MATLAB software.

**Download _MFeaST_ installation file:**

https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/bd5a058d-d51c-4ac6-ae85-f9803c549203

**Install _MFeaST_ for Windows**

https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/81ef611e-208d-4c4a-9d73-29d3fbbb6366

**Install _MFeaST_ for Mac**

https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/3d388621-401d-4754-b2c1-3e681119d59f

## Errors during *MFeaST* installation.<a name="troubleshooting"></a> 

**Potential Solution:**
- Windows operating system:
    -  _“Do you want to allow this app from an unknown publisher to make changes to your device?”_
        - Select “Yes”. Make sure you are running as an administrator.

- Mac operating system:
    - _"MolecularFeaST.app cannot be opened because the developer cannot be verified."_ **Note:** This error and solution were generated on macOS Monterey v12.5.1. If you are running another version of macOS, this solution may or may not work for you. 
        - Cancel current installation (Figure 8A).
        - Click the “System Preferences” icon ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/4604f734-870d-4e09-a6ca-330269687786) in the Dock or click the Apple menu from the toolbar  ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/0b8104e1-dd11-440c-b9e0-7d09783e2fbd) > “System Preferences”. Click “Security & Privacy” ![image](https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/1449683b-54bf-4c31-8e14-e5b892728d11) (Figure 8B).
        - From the top menu, select “General” (Figure 8C). Under “Allow apps downloaded from:”, make sure “App Store and identified developers” is selected. You may have to enter your administrator password to apply changes.
        - Click the lock icon in the left-hand corner beside “Click the lock to make changes.” A message should appear in the “Allow apps downloaded from:” section indicating MolecularFeaST was blocked. Select the “Open Anyway” button beside this message. A pop-up window will appear, select “Open” (Figure 8D).
        - _MFeaST_ will begin installing. You may get a pop-up message “java wants to make changes” (Figure 8E). Type in your administrator password and select “OK”.

    - _"Cannot locate a valid install area"_
        - Make sure you download and install the “One-step installation” version of _MFeaST_ from https://www.renwicklab.com/downloads/.

<div align="center">
    <img src="https://github.com/Renwick-Lab/RNA-ML-Sample-Hierarchical-Classification/assets/57264991/f1d322f8-55db-485f-b698-b2964079ad12">
</div>

**_MFeaST_ “Developer cannot be verified” Installation error on Mac OS.** (A) “Developer cannot be verified” error will window pop-up when trying to open _MFeaST_ for the first time. Click “Cancel.” (B) Open “System Preferences” and select “Security and Privacy.” (C) Under the “General” tab of the “Security and Privacy” window, warning for _MolecularFeast_ will appear. Select “Open Anyway.” (D) Click the _MFeaST_ icon to open again. Click “Open” on pop-up “Developer cannot be verified” error window. (E) Enter administrator password if prompted. 
   
