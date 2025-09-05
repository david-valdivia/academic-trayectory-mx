# Academic Trajectory SVG Generator

Automated system to generate academic credential visualizations from Mexico's SEP professional certificate database.

![](https://raw.githubusercontent.com/david-valdivia/academic-trayectory-mx/main/outputs/academic_trajectory.svg)

## Warning

This project was developed for educational purposes only. It is not intended for production use without proper security, performance, and best practices considerations.

## Quick Setup

### 1. Create New Repository
- Create new repository (do not fork) [HERE](https://github.com/david-valdivia/academic-trayectory-mx/create)

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
├── generate.sh
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
![](https://raw.githubusercontent.com/david-valdivia/academic-trayectory-mx/main/outputs/academic_trajectory.svg)
```

Replace `USERNAME` and `REPOSITORY` with your GitHub details.

## Requirements
- Valid Mexican professional certificates
- Repository secrets configured
- GitHub Actions enabled

---
## Data Usage Agreement

This application requires personal information to function properly. By using this software, you consent to provide and allow the use of such information for the application's operation only.

No data is collected or stored permanently.

## License

This project is distributed under the MIT License.

You are free to:
- Use commercially
- Modify
- Distribute
- Use privately

No warranties: The software is provided "as is", without warranties of any kind.
