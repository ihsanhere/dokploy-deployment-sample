# Dokploy Deployment Sample (Next.js + Payload CMS)

This sample demonstrates a Next.js frontend with Payload CMS backend requiring MongoDB. Follow these steps to test the Docker build network integration solution.

## Prerequisites
- Dokploy instance running
- GitHub account with repository access

## Deployment Steps

### 1. Create MongoDB Service
1. In Dokploy:  
   **Services → New Service → Database**  
   - Name: `mongo-db`  
   - Type: MongoDB  
   - Version: 5.0+ (recommended)  

2. Note the **Internal Connection URL** (format: `mongodb://<service-name>:27017`)

### 2. Deploy Application
1. **Create New Application**  
   - Name: `dokploy-sample-app`  
   - Git Provider: Select your provider  
   - Repository URL: `https://github.com/ihsanhere/dokploy-deployment-sample`  

2. **Build Method**  
   - Select: `Dockerfile`  

3. **Environment Variables**  
   ```env
   DATABASE_URI=mongodb://mongo-db:27017/dokploy-deployment-sample
   PAYLOAD_SECRET=<your_random_string>
   NEXT_PUBLIC_SERVER_URL=http://localhost:3000
   CRON_SECRET=<your_random_string>
   PREVIEW_SECRET=<your_random_string>
   ```
   - Replace `<your_random_string>` with secure values (use password generator)

   - Replace the `DATABASE_URI` with the **Internal Connection URL** from the mongo db service

### 4. Verify Deployment
1. Check build logs for successful MongoDB connection  
2. Access Payload CMS admin at `/admin`  
3. Check app logs to see nextjs running successfully

## Important Notes
- 🔒 Database is **not publicly exposed** - internal networking only  
- 🔄 UFW firewall rules won't affect internal service communication  
- ⚠️ Other build methods (Nixpacks/Heroku) require separate network configuration  

[View Source Code](https://github.com/ihsanhere/dokploy-deployment-sample) | [Dokploy Fork](https://github.com/ihsanhere/dokploy)
