# GitHub Release Guide for ApoLoudness v0.3.3

## Prerequisites

1. Ensure `deployment\ApoLoudness_v0.3.3_Setup.exe` exists and has been tested
2. Have your GitHub account credentials ready
3. Ensure you have push access to the repository

## Step 1: Commit and Push Changes

```bash
# Add all changes
git add .

# Commit with version message
git commit -m "Release v0.3.3

- Fixed Convolution path to use ../Filters/
- Fixed Real SPL calculation when Target equals Reference
- Improved Auto Offset wheel accumulator logic
- Fixed mouse hook interference with browser scrolling
- Removed debug console
- Fixed Calibration mode to start with Reference 80
- Removed Reference Level Selection UI
- Added calibration backup with timestamp
- Code cleanup and improvements"

# Push to main branch
git push origin main
```

## Step 2: Create GitHub Release

### Via GitHub Web Interface:

1. Go to: https://github.com/grisys83/APO-Loudness/releases
2. Click "Draft a new release"
3. Click "Choose a tag" and type: `v0.3.3`
4. Select "Create new tag: v0.3.3 on publish"
5. Release title: `ApoLoudness v0.3.3`
6. Copy the content from `RELEASE_NOTES_v0.3.3.md` to the description
7. Attach `deployment\ApoLoudness_v0.3.3_Setup.exe`
8. Check "Set as the latest release"
9. Click "Publish release"

### Via GitHub CLI (if installed):

```bash
# Create tag
git tag -a v0.3.3 -m "Release v0.3.3"

# Push tag
git push origin v0.3.3

# Create release with GitHub CLI
gh release create v0.3.3 \
  --title "ApoLoudness v0.3.3" \
  --notes-file RELEASE_NOTES_v0.3.3.md \
  deployment/ApoLoudness_v0.3.3_Setup.exe
```

## Step 3: Verify Release

1. Check that the release appears at: https://github.com/grisys83/APO-Loudness/releases
2. Verify the download link works
3. Update the main README.md if needed to point to the new release

## Step 4: Post-Release Tasks

- [ ] Announce the release in relevant forums/communities
- [ ] Monitor issue tracker for any immediate problems
- [ ] Update project wiki/documentation if applicable

## Optional: Generate SHA256 Checksum

```powershell
# In PowerShell
Get-FileHash deployment\ApoLoudness_v0.3.3_Setup.exe -Algorithm SHA256
```

Add the checksum to the release notes for verification.