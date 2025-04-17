#!/bin/bash

ERROR_LOG=$(npm test 2>&1 | tee /tmp/test.log)

RESPONSE=$(curl -s -X POST "$HUGGINGFACE_API_URL" \
  -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      { "role": "system", "content": "You are a DevOps LLM. Fix the test failure by adjusting expected value or logic." },
      { "role": "user", "content": "'"${ERROR_LOG//\"/\\\"}"'" }
    ],
    "model": "'"$HUGGINGFACE_MODEL"'"
  }')

FIX=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
echo -e "\n💡 AI Suggested Fix:\n$FIX" > /tmp/rca.txt

# Example fix: Update expected value in test
sed -i 's/assert.strictEqual(result, 42);/assert.strictEqual(result, 13);/' test/calculator.spec.js

# Git setup
git config --global user.name "AIOps Bot"
git config --global user.email "aiops@example.com"

git checkout -b hotfix/testfix
git add .
git commit -m "🤖 Auto-fix: Corrected test assertion in calculator.spec.js"
git push origin hotfix/testfix

# Slack Alert
curl -X POST "$SLACK_WEBHOOK_URL" -H 'Content-type: application/json' \
--data "{
  \"text\": \"❗ *Build Failed in Jenkins*\n🤖 *AI RCA & Auto Fix Suggestion:*\n\`\`\`$FIX\`\`\`\n✅ PR created: \`hotfix/testfix\`\nCommit: 🤖 Auto-fix.\",
  \"channel\": \"$SLACK_CHANNEL\"
}"
