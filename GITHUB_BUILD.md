# GitHub build guide — v0.6

1. Create a new GitHub repository, e.g. `EnglishAdventureKids`.
2. Upload the contents of this folder to the repository (the files inside this folder, not the parent folder).
3. Commit to the `main` branch.
4. Open GitHub -> Actions -> Build Android APK.
5. Run the workflow if it did not start automatically.
6. When the job is green, open the workflow run and download the artifact named:
   `EnglishAdventureKids-Android`
7. Extract the artifact and install the resulting APK on the Galaxy Tab S10.

No GitHub password/token should be placed in the project files.

If the first run reports an Android export/signing error, send the Actions error text or a screenshot of the failed step and the project can be corrected from that exact error.
