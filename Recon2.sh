#!/bin/bash

# Parse command-line arguments
while getopts ":d:" opt; do
  case ${opt} in
    d ) url=$OPTARG;;
    \? ) echo "Usage: $0 -d <url>"; exit 1;;
    : ) echo "Invalid option: $OPTARG requires an argument"; exit 1;;
  esac
done
shift $((OPTIND -1))

# Check if URL is provided
if [ -z "$url" ]; then
  echo "Error: Please provide a URL."
  echo "Usage: $0 -d <url>"
  exit 1
fi

# Set the output file
output_file="recon_results.txt"

# ANSI color codes
green='\033[0;32m'
cyan='\033[0;36m'
yellow='\033[1;33m'
red='\033[0;31m'
nc='\033[0m' # No Color

# Perform subdomain enumeration
echo -e "${cyan}Performing subdomain enumeration for $url ...${nc}"
subdomains=$(subfinder -d $url -src)
subdomains+=$(massdns -d $url)
echo $subdomains >> $output_file

# Perform directory and file discovery
echo -e "${cyan}Performing directory and file discovery for $url ...${nc}"
dirsearch -u $url -e * >> $output_file

# Check for open ports and running services
echo -e "${cyan}Performing port scan for $url ...${nc}"
nmap -sC -sV $url >> $output_file

# Check for known vulnerabilities
echo -e "${cyan}Checking for known vulnerabilities for $url ...${nc}"
nmap -sV --script vulners --script-args mincvss=5.0 $url >> $output_file

# Retrieve JavaScript files
echo -e "${cyan}Retrieving JavaScript files for $url ...${nc}"
getJS -u $url >> $output_file

# Find links
echo -e "${cyan}Finding links for $url ...${nc}"
GoLinkFinder -d $url >> $output_file

# Get all URLs
echo -e "${cyan}Retrieving all URLs for $url ...${nc}"
gau $url >> $output_file

# Check for URLs in Wayback Machine
#echo -e "${cyan}Checking for URLs in Wayback Machine for $url ...${nc}"
#WayBackUrls -u $url >> $output_file

# Check for robots.txt in Wayback Machine
echo -e "${cyan}Checking for robots.txt in Wayback Machine for $url ...${nc}"
waybackrobots -c 50 -d $url >> $output_file

# Check for Forced Browsing vulnerabilities
echo -e "${cyan}Checking for Forced Browsing vulnerabilities for $url ...${nc}"
ffuf -u $url >> $output_file

# Check for XSS vulnerabilities
#echo -e "${cyan}Checking for XSS vulnerabilities for $url ...${nc}"
#XSSHunter -u $url >> $output_file

# Check for SQL injection vulnerabilities
#echo -e "${cyan}Checking for SQL injection vulnerabilities for $url ...${nc}"
#sqlmap -u $url >> $output_file

# Check for XXE vulnerabilities
#echo -e "${cyan}Checking for XXE vulnerabilities for $url ...${nc}"
#XXEInjector -u $url >> $output_file

# Check for SSRF vulnerabilities
#echo -e "${cyan}Checking for SSRF vulnerabilities for $url ...${nc}"
#SSRFDetector -u $url >> $output_file

# Check for secrets in Git repository
echo -e "${cyan}Checking for secrets in Git repository for $url ...${nc}"
GitTools -u $url >> $output_file
gitallsecrets -u $url >> $output_file

# Check for race condition vulnerabilities
echo -e "${cyan}Checking for race condition vulnerabilities for $url ...${nc}"
RaceTheWeb -u $url >> $output_file

# Check for CORS misconfigurations
echo -e "${cyan}Checking for CORS misconfigurations for $url ...${nc}"
CORStest -u $url >> $output_file

# Take screenshots
echo -e "${cyan}Taking screenshots for $url ...${nc}"
EyeWitness -u $url >> $output_file

# Check for parameter tampering vulnerabilities
echo -e "${cyan}Checking for parameter tampering vulnerabilities for $url ...${nc}"
parameth -u $url >> $output_file

echo -e "${green}Recon complete for $url!${nc}"
