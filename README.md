# Academic Trajectory SVG Generator

Automated system to generate academic credential visualizations from Mexico's SEP professional certificate database.

## Quick Setup

### 1. Create New Repository
- Create new repository (do not fork)
- Clone locally
- Copy all files from source project

### 2. Configure Repository Secrets
Navigate to: **Settings > Secrets and variables > Actions**

Add three repository secrets:
- `NAME`: First name(s)
- `APAT`: Paternal surname
- `AMAT`: Maternal surname

### 3. Update Git Configuration
Edit `.github/workflows/ci.yml`:
```yaml
- name: Configure Git
  run: |
    git config --global user.email "your-email@domain.com"
    git config --global user.name "your-username"
```

### 4. Enable Actions
- Go to **Actions** tab
- Enable GitHub Actions if prompted
- Push to `main` branch to trigger workflow

## File Structure
```
├── templates/main.txt
├── templates/card.txt
├── genera.sh
├── .github/workflows/ci.yml
└── outputs/ (auto-generated)
```

## Usage
- Manual trigger: Actions tab > CI > Run workflow
- Automatic trigger: Push to main branch
- Output: `outputs/academic_trajectory.svg`

## GitHub Profile Integration
Add to your README.md:

```markdown
![Academic Trajectory](https://raw.githubusercontent.com/david-valdivia/REPOSITORY/main/outputs/academic_trajectory.svg)
```

Replace `USERNAME` and `REPOSITORY` with your GitHub details.

## Requirements
- Valid Mexican professional certificates
- Repository secrets configured
- GitHub Actions enabled