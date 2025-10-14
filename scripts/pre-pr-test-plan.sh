#!/bin/bash

# Pre-PR Test Plan Generation Script
# This script generates a test plan before creating a PR and validates test coverage

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEST_PLAN_DIR="docs/testing"
TEST_PLAN_FILE="$TEST_PLAN_DIR/test-plan-$(date +%Y%m%d-%H%M%S).md"
CURRENT_BRANCH=$(git branch --show-current)
BASE_BRANCH=${1:-main}

echo -e "${BLUE}🚀 Starting Pre-PR Test Plan Generation${NC}"
echo -e "${BLUE}Branch: $CURRENT_BRANCH${NC}"
echo -e "${BLUE}Base: $BASE_BRANCH${NC}"

# Create testing directory if it doesn't exist
mkdir -p "$TEST_PLAN_DIR"

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Not in a git repository${NC}"
        exit 1
    fi
}

# Function to check if there are uncommitted changes
check_uncommitted_changes() {
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes${NC}"
        echo -e "${YELLOW}   Consider committing or stashing them before creating a PR${NC}"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Function to generate test plan using Cursor
generate_test_plan() {
    echo -e "${BLUE}📋 Generating test plan...${NC}"
    
    # Create the test plan file with header
    cat > "$TEST_PLAN_FILE" << EOF
# Test Plan - $CURRENT_BRANCH

**Generated**: $(date)
**Branch**: $CURRENT_BRANCH
**Base**: $BASE_BRANCH
**Author**: $(git config user.name)

## Repository Analysis

EOF

    # Add repository information
    echo "### Project Information" >> "$TEST_PLAN_FILE"
    echo "- **Repository**: $(git remote get-url origin 2>/dev/null || echo 'Local repository')" >> "$TEST_PLAN_FILE"
    echo "- **Last Commit**: $(git log -1 --pretty=format:'%h - %s (%an, %ar)')" >> "$TEST_PLAN_FILE"
    echo "- **Files Changed**: $(git diff --name-only $BASE_BRANCH...HEAD | wc -l) files" >> "$TEST_PLAN_FILE"
    echo "" >> "$TEST_PLAN_FILE"

    # Add changed files
    echo "### Changed Files" >> "$TEST_PLAN_FILE"
    git diff --name-only $BASE_BRANCH...HEAD | while read file; do
        echo "- \`$file\`" >> "$TEST_PLAN_FILE"
    done
    echo "" >> "$TEST_PLAN_FILE"

    # Add diff summary
    echo "### Changes Summary" >> "$TEST_PLAN_FILE"
    echo '```diff' >> "$TEST_PLAN_FILE"
    git diff --stat $BASE_BRANCH...HEAD >> "$TEST_PLAN_FILE"
    echo '```' >> "$TEST_PLAN_FILE"
    echo "" >> "$TEST_PLAN_FILE"

    echo -e "${GREEN}✅ Test plan structure created${NC}"
    echo -e "${YELLOW}📝 Please use Cursor to complete the test plan using the team instructions${NC}"
    echo -e "${YELLOW}   File location: $TEST_PLAN_FILE${NC}"
}

# Function to validate test coverage
validate_test_coverage() {
    echo -e "${BLUE}🔍 Validating test coverage...${NC}"
    
    # Check for common test files
    local test_files=()
    test_files+=($(find . -name "*.test.js" -o -name "*.test.ts" -o -name "*.spec.js" -o -name "*.spec.ts" 2>/dev/null || true))
    test_files+=($(find . -name "__tests__" -type d 2>/dev/null || true))
    test_files+=($(find . -name "tests" -type d 2>/dev/null || true))
    test_files+=($(find . -name "test" -type d 2>/dev/null || true))
    
    if [ ${#test_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No test files found${NC}"
        echo -e "${YELLOW}   Consider adding tests for your changes${NC}"
    else
        echo -e "${GREEN}✅ Found test files:${NC}"
        printf '%s\n' "${test_files[@]}" | head -10
        if [ ${#test_files[@]} -gt 10 ]; then
            echo -e "${BLUE}   ... and $(( ${#test_files[@]} - 10 )) more${NC}"
        fi
    fi
    
    # Check for test configuration files
    local config_files=()
    config_files+=($(find . -name "jest.config.*" -o -name "vitest.config.*" -o -name "cypress.config.*" 2>/dev/null || true))
    config_files+=($(find . -name "package.json" -exec grep -l "test" {} \; 2>/dev/null || true))
    
    if [ ${#config_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No test configuration found${NC}"
    else
        echo -e "${GREEN}✅ Found test configuration:${NC}"
        printf '%s\n' "${config_files[@]}"
    fi
}

# Function to run tests if available
run_tests() {
    echo -e "${BLUE}🧪 Running tests...${NC}"
    
    # Check for package.json and test scripts
    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json; then
            echo -e "${BLUE}Running npm test...${NC}"
            npm test || echo -e "${YELLOW}⚠️  Tests failed or not configured${NC}"
        fi
        
        if grep -q '"test:ci"' package.json; then
            echo -e "${BLUE}Running npm run test:ci...${NC}"
            npm run test:ci || echo -e "${YELLOW}⚠️  CI tests failed or not configured${NC}"
        fi
    fi
    
    # Check for other test runners
    if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
        echo -e "${BLUE}Running pytest...${NC}"
        python -m pytest --tb=short || echo -e "${YELLOW}⚠️  Python tests failed or not configured${NC}"
    fi
}

# Function to create PR with test plan
create_pr_with_test_plan() {
    echo -e "${BLUE}📝 Creating PR with test plan...${NC}"
    
    # Check if gh CLI is available
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI not found. Please install gh CLI to create PRs automatically${NC}"
        echo -e "${YELLOW}   You can create the PR manually and include the test plan${NC}"
        return 1
    fi
    
    # Check if we're on GitHub
    if ! git remote get-url origin | grep -q github.com; then
        echo -e "${YELLOW}⚠️  Not a GitHub repository. Please create PR manually${NC}"
        return 1
    fi
    
    # Create PR with test plan
    local pr_title="$(git log -1 --pretty=format:'%s')"
    local pr_body="## Test Plan

This PR includes a comprehensive test plan generated automatically.

**Test Plan**: \`$TEST_PLAN_FILE\`

### Changes Summary
$(git diff --stat $BASE_BRANCH...HEAD)

### Testing Checklist
- [ ] Test plan reviewed and approved
- [ ] All tests passing
- [ ] Code coverage meets requirements
- [ ] Manual testing completed
- [ ] Security review completed (if applicable)

### Test Plan Preview
\`\`\`
$(head -20 "$TEST_PLAN_FILE")
\`\`\`

*Please review the complete test plan in the linked file.*"

    gh pr create \
        --title "$pr_title" \
        --body "$pr_body" \
        --base "$BASE_BRANCH" \
        --head "$CURRENT_BRANCH" \
        --assignee "@me" || {
        echo -e "${YELLOW}⚠️  Failed to create PR automatically${NC}"
        echo -e "${YELLOW}   Please create PR manually and include the test plan${NC}"
        return 1
    }
    
    echo -e "${GREEN}✅ PR created successfully with test plan${NC}"
}

# Function to show next steps
show_next_steps() {
    echo -e "${BLUE}📋 Next Steps:${NC}"
    echo -e "${BLUE}1. Open $TEST_PLAN_FILE in Cursor${NC}"
    echo -e "${BLUE}2. Use the team instructions to complete the test plan${NC}"
    echo -e "${BLUE}3. Run tests and update the test plan with results${NC}"
    echo -e "${BLUE}4. Create PR with: gh pr create --title 'Your Title' --body-file $TEST_PLAN_FILE${NC}"
    echo ""
    echo -e "${GREEN}🎯 Test Plan Location: $TEST_PLAN_FILE${NC}"
}

# Main execution
main() {
    check_git_repo
    check_uncommitted_changes
    generate_test_plan
    validate_test_coverage
    run_tests
    
    # Ask if user wants to create PR
    read -p "Create PR with test plan? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        create_pr_with_test_plan
    else
        show_next_steps
    fi
}

# Run main function
main "$@"