# Port Forwarding Guide - Access from Mobile Data

## 🎯 What is Port Forwarding?

Port forwarding allows external devices (like your phone on mobile data) to access your computer's API server through your router.

## 🔧 Setup Steps

### Step 1: Find Your Router's IP
```cmd
ipconfig
```
Look for "Default Gateway" - this is your router's IP (usually `192.168.1.1`)

### Step 2: Access Router Settings
1. Open web browser
2. Go to: `http://192.168.1.1` (or your router's IP)
3. Login with admin credentials (check router manual)

### Step 3: Configure Port Forwarding
1. Find **"Port Forwarding"** or **"Virtual Server"** section
2. Add new rule:
   - **External Port**: 8000
   - **Internal Port**: 8000
   - **Internal IP**: 192.168.1.4 (your computer's IP)
   - **Protocol**: TCP
   - **Status**: Enabled

### Step 4: Get Your Public IP
1. Go to: https://whatismyipaddress.com/
2. Note your public IP address

### Step 5: Update App Configuration
Update `lib/core/api_service.dart`:
```dart
static List<String> get alternativeUrls => [
  'http://YOUR_PUBLIC_IP:8000',  // Replace with your public IP
  'http://192.168.1.4:8000',     // Keep local IP as backup
  // ... other URLs
];
```

## ⚠️ Security Considerations

### Risks:
- Your API becomes accessible from the internet
- Anyone can potentially access your server
- No authentication by default

### Recommendations:
- Only enable when needed
- Use strong firewall rules
- Consider adding authentication
- Monitor access logs

## 🧪 Testing

### Test from Mobile Data:
1. Turn off WiFi on your phone
2. Use mobile data
3. Open app
4. Check if WiFi icon turns green

### Test from Different Network:
1. Go to a friend's house
2. Connect to their WiFi
3. Test the app

## 🔄 Alternative: Dynamic DNS

If your public IP changes frequently:

### Step 1: Sign up for Dynamic DNS
- No-IP (free)
- DuckDNS (free)
- DynDNS

### Step 2: Configure Router
- Enable Dynamic DNS in router settings
- Enter your DDNS credentials

### Step 3: Update App
```dart
'http://yourdomain.ddns.net:8000'
```

## 🛡️ Security Best Practices

### For Personal Use:
- ✅ Port forwarding is acceptable
- ✅ Keep API server local
- ✅ Disable when not needed

### For Production:
- ❌ Don't use port forwarding
- ✅ Deploy to cloud server
- ✅ Use HTTPS
- ✅ Add authentication
- ✅ Implement rate limiting

## 📱 Usage Workflow

### When at Home (WiFi):
- Use local IP: `192.168.1.4:8000`
- Faster connection
- More secure

### When Away (Mobile Data):
- Use public IP: `YOUR_PUBLIC_IP:8000`
- Slower connection
- Less secure

## 🔧 Troubleshooting

### Port Forwarding Not Working:
1. Check router settings
2. Verify firewall rules
3. Test with telnet: `telnet YOUR_PUBLIC_IP 8000`
4. Check ISP restrictions

### Connection Issues:
1. Verify API server is running
2. Check public IP hasn't changed
3. Test from different network
4. Check router logs

## 🎯 Quick Setup Checklist

- [ ] Configure port forwarding in router
- [ ] Get public IP address
- [ ] Update app configuration
- [ ] Test from mobile data
- [ ] Verify security settings

**Your app can now work on mobile data!** 📱✨ 