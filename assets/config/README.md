# Configuration Management

## 📁 File Structure

```
assets/config/
├── config.dev.template.json      # Development template
├── config.staging.template.json  # Staging template  
├── config.production.template.json # Production template
├── config.dev.json               # Generated (gitignored)
├── config.staging.json           # Generated (gitignored)
└── config.json                   # Generated (gitignored)
```

## 🔧 Setup Instructions

### 1. **Copy Environment Template**
```bash
cp env.example .env
```

### 2. **Fill in Your Values**
Edit `.env` file:
```bash
WEB3AUTH_CLIENT_ID=your_actual_client_id_here
```

### 3. **Generate Config Files**
```bash
# Load environment variables
source .env

# Generate config for specific environment
./scripts/generate-config.sh development
./scripts/generate-config.sh staging
./scripts/generate-config.sh production
```

### 4. **Or Generate All at Once**
```bash
source .env
for env in development staging production; do
    ./scripts/generate-config.sh $env
done
```

## 🔒 Security Notes

- ✅ **Template files** are safe to commit (no sensitive data)
- ❌ **Generated config files** are gitignored (contain sensitive data)
- 🔑 **Environment variables** are gitignored (contain secrets)

## 🚀 Build Commands

The build scripts automatically load environment variables:

```bash
# Development
./scripts/run.sh development

# Staging  
./scripts/run.sh staging

# Production
./scripts/run.sh production
```

## 🔄 Adding New Sensitive Config

1. **Add placeholder to template:**
   ```json
   "NEW_SERVICE": {
     "api_key": "${NEW_SERVICE_API_KEY}"
   }
   ```

2. **Add to .env.example:**
   ```bash
   NEW_SERVICE_API_KEY=your_api_key_here
   ```

3. **Update .env file with actual value**

4. **Regenerate configs:**
   ```bash
   source .env
   ./scripts/generate-config.sh development
   ```
