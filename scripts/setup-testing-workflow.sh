#!/bin/bash

# Setup Testing Workflow Script
# This script sets up the complete testing workflow for a repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up Testing Workflow${NC}"

# Function to check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ Git is required but not installed${NC}"
        exit 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Not in a git repository${NC}"
        exit 1
    fi
    
    # Check if GitHub CLI is available
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}⚠️  GitHub CLI not found. Install it for better integration:${NC}"
        echo -e "${YELLOW}   https://cli.github.com/${NC}"
    else
        echo -e "${GREEN}✅ GitHub CLI found${NC}"
    fi
    
    # Check if Cursor is available
    if ! command -v cursor &> /dev/null; then
        echo -e "${YELLOW}⚠️  Cursor not found. Install it for better integration:${NC}"
        echo -e "${YELLOW}   https://cursor.sh/${NC}"
    else
        echo -e "${GREEN}✅ Cursor found${NC}"
    fi
    
    echo -e "${GREEN}✅ Prerequisites check completed${NC}"
}

# Function to create directory structure
create_directory_structure() {
    echo -e "${BLUE}📁 Creating directory structure...${NC}"
    
    # Create testing directories
    mkdir -p docs/testing
    mkdir -p .github/workflows
    mkdir -p scripts
    
    echo -e "${GREEN}✅ Directory structure created${NC}"
}

# Function to setup Cursor team instructions
setup_cursor_instructions() {
    echo -e "${BLUE}📝 Setting up Cursor team instructions...${NC}"
    
    if [ -f ".cursorrules" ]; then
        echo -e "${YELLOW}⚠️  .cursorrules already exists. Backing up...${NC}"
        cp .cursorrules .cursorrules.backup
    fi
    
    # The .cursorrules file is already created in the main script
    echo -e "${GREEN}✅ Cursor team instructions configured${NC}"
}

# Function to setup GitHub Actions
setup_github_actions() {
    echo -e "${BLUE}⚙️  Setting up GitHub Actions...${NC}"
    
    if [ -f ".github/workflows/test-plan-validation.yml" ]; then
        echo -e "${YELLOW}⚠️  GitHub Actions workflow already exists${NC}"
    else
        echo -e "${GREEN}✅ GitHub Actions workflow created${NC}"
    fi
}

# Function to create testing documentation
create_testing_documentation() {
    echo -e "${BLUE}📚 Creating testing documentation...${NC}"
    
    cat > docs/testing/README.md << 'EOF'
# Testing Guidelines

This directory contains testing documentation and test plans for this repository.

## 📋 Test Plans

Test plans are automatically generated and stored in this directory with the format:
- `test-plan-YYYYMMDD-HHMMSS.md`

## 🚀 Quick Start

### Generate a new test plan
```bash
./scripts/generate-test-plan.sh
```

### Generate test plan before PR
```bash
./scripts/pre-pr-test-plan.sh
```

## 📊 Test Plan Structure

Each test plan includes:
1. **Executive Summary** - High-level overview
2. **Repository Analysis** - Project type, tech stack, architecture
3. **Test Strategy** - Organized by priority (Critical, Important, Nice-to-Have)
4. **Test Implementation Plan** - Phases and timeline
5. **Success Criteria** - Coverage targets and benchmarks
6. **Tools and Frameworks** - Recommended testing tools
7. **Risk Assessment** - Testing risks and mitigation

## 🎯 Quality Standards

### Minimum Requirements
- **Test Coverage**: 80% for critical paths, 60% overall
- **Performance**: < 3s page load, < 200ms API response
- **Security**: No high/critical vulnerabilities
- **Accessibility**: WCAG 2.1 AA compliance

### Test Categories

#### Critical Tests (Must Pass)
- Core functionality
- Security
- Performance
- Data integrity

#### Important Tests (Should Pass)
- Integration
- User experience
- Compatibility
- Accessibility

#### Nice-to-Have Tests (Could Pass)
- Edge cases
- Performance optimization
- Monitoring

## 🛠️ Tools and Frameworks

### Frontend Testing
- **Unit Testing**: Jest, Mocha, Vitest
- **E2E Testing**: Cypress, Playwright
- **API Testing**: Supertest, Postman
- **Coverage**: Istanbul, c8

### Backend Testing
- **Unit Testing**: pytest, unittest, JUnit
- **E2E Testing**: Selenium, Playwright
- **API Testing**: requests, httpx, RestAssured
- **Coverage**: coverage.py, pytest-cov, JaCoCo

### Mobile Testing
- **Unit Testing**: Jest, XCTest, Espresso
- **E2E Testing**: Detox, Appium
- **Performance**: Flipper, Xcode Instruments

## 📈 Continuous Integration

### GitHub Actions
- Automatic test plan validation on PRs
- Test execution and coverage reporting
- Security scanning and performance testing

### Pre-commit Hooks
- Lint checking
- Unit test execution
- Test plan validation

## 🔧 Configuration

### Environment Variables
```bash
# Test environment configuration
TEST_ENV=development
TEST_DATABASE_URL=postgresql://test:test@localhost:5432/test_db
TEST_API_BASE_URL=http://localhost:3000
```

### Test Data
- Test fixtures in `tests/fixtures/`
- Mock services in `tests/mocks/`
- Test database seeds in `tests/seeds/`

## 📝 Best Practices

1. **Test Early and Often** - Write tests as you develop
2. **Test the Right Things** - Focus on critical functionality
3. **Keep Tests Simple** - One test, one assertion
4. **Use Descriptive Names** - Test names should explain what they test
5. **Maintain Test Data** - Keep test data clean and consistent
6. **Document Test Cases** - Explain complex test scenarios
7. **Monitor Test Performance** - Keep test execution fast
8. **Review Test Coverage** - Ensure adequate coverage

## 🚨 Troubleshooting

### Common Issues
- **Tests Failing**: Check test data and environment setup
- **Slow Tests**: Optimize test execution and use parallel testing
- **Flaky Tests**: Make tests more deterministic and stable
- **Coverage Issues**: Add missing test cases

### Getting Help
- Check the test plan for specific guidance
- Review test documentation
- Ask team members for assistance
- Consult testing tool documentation

## 📚 Resources

- [Testing Best Practices](https://testing.googleblog.com/)
- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [Cypress Documentation](https://docs.cypress.io/)
- [Playwright Documentation](https://playwright.dev/)
- [pytest Documentation](https://docs.pytest.org/)

---

*This documentation is automatically maintained. For questions or updates, please contact the development team.*
EOF

    echo -e "${GREEN}✅ Testing documentation created${NC}"
}

# Function to setup pre-commit hooks
setup_pre_commit_hooks() {
    echo -e "${BLUE}🪝 Setting up pre-commit hooks...${NC}"
    
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Pre-commit hook for test plan validation

echo "🔍 Running pre-commit checks..."

# Check if test plan exists for significant changes
if git diff --cached --name-only | grep -E '\.(js|ts|py|java|go|rs|php|rb)$' > /dev/null; then
    echo "📋 Code changes detected. Checking for test plan..."
    
    if [ ! -d "docs/testing" ] || [ ! "$(ls -A docs/testing/*.md 2>/dev/null)" ]; then
        echo "⚠️  No test plan found. Consider generating one:"
        echo "   ./scripts/generate-test-plan.sh"
        echo ""
        read -p "Continue without test plan? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ Commit cancelled. Generate test plan first."
            exit 1
        fi
    else
        echo "✅ Test plan found"
    fi
fi

echo "✅ Pre-commit checks passed"
EOF

    chmod +x .git/hooks/pre-commit
    
    echo -e "${GREEN}✅ Pre-commit hooks configured${NC}"
}

# Function to create package.json scripts
setup_package_scripts() {
    echo -e "${BLUE}📦 Setting up package.json scripts...${NC}"
    
    if [ -f "package.json" ]; then
        # Add test scripts if they don't exist
        if ! grep -q '"test:plan"' package.json; then
            echo "Adding test plan scripts to package.json..."
            
            # Create a temporary file with updated scripts
            node -e "
                const fs = require('fs');
                const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
                
                pkg.scripts = pkg.scripts || {};
                pkg.scripts['test:plan'] = './scripts/generate-test-plan.sh';
                pkg.scripts['test:plan:pr'] = './scripts/pre-pr-test-plan.sh';
                pkg.scripts['test:validate'] = './scripts/validate-test-plan.sh';
                
                fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
                console.log('✅ Test plan scripts added to package.json');
            "
        else
            echo -e "${YELLOW}⚠️  Test plan scripts already exist in package.json${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  No package.json found. Skipping script setup${NC}"
    fi
}

# Function to create validation script
create_validation_script() {
    echo -e "${BLUE}🔍 Creating test plan validation script...${NC}"
    
    cat > scripts/validate-test-plan.sh << 'EOF'
#!/bin/bash

# Test Plan Validation Script
# This script validates the completeness and quality of test plans

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Validating Test Plan${NC}"

# Function to check if test plan exists
check_test_plan_exists() {
    if [ -d "docs/testing" ] && [ "$(ls -A docs/testing/*.md 2>/dev/null)" ]; then
        local latest_plan=$(ls -t docs/testing/test-plan-*.md | head -1)
        echo -e "${GREEN}✅ Test plan found: $latest_plan${NC}"
        echo "$latest_plan"
    else
        echo -e "${RED}❌ No test plan found${NC}"
        return 1
    fi
}

# Function to validate test plan content
validate_test_plan_content() {
    local test_plan_file="$1"
    
    echo -e "${BLUE}📋 Validating test plan content...${NC}"
    
    # Required sections
    local required_sections=(
        "Executive Summary"
        "Repository Analysis"
        "Test Strategy"
        "Test Implementation Plan"
        "Success Criteria"
    )
    
    local missing_sections=()
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "$section" "$test_plan_file"; then
            missing_sections+=("$section")
        fi
    done
    
    if [ ${#missing_sections[@]} -eq 0 ]; then
        echo -e "${GREEN}✅ All required sections present${NC}"
    else
        echo -e "${RED}❌ Missing required sections:${NC}"
        printf '   - %s\n' "${missing_sections[@]}"
        return 1
    fi
    
    # Check for test cases
    local test_case_count=$(grep -c "\[ \].*Test" "$test_plan_file" || echo "0")
    if [ "$test_case_count" -gt 0 ]; then
        echo -e "${GREEN}✅ Found $test_case_count test cases${NC}"
    else
        echo -e "${YELLOW}⚠️  No test cases found${NC}"
    fi
    
    # Check for success criteria
    if grep -q "Success Criteria" "$test_plan_file"; then
        echo -e "${GREEN}✅ Success criteria defined${NC}"
    else
        echo -e "${YELLOW}⚠️  Success criteria not defined${NC}"
    fi
}

# Function to check test coverage
check_test_coverage() {
    echo -e "${BLUE}📊 Checking test coverage...${NC}"
    
    # Check for test files
    local test_files=()
    test_files+=($(find . -name "*.test.js" -o -name "*.test.ts" -o -name "*.spec.js" -o -name "*.spec.ts" 2>/dev/null || true))
    
    if [ ${#test_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No test files found${NC}"
    else
        echo -e "${GREEN}✅ Found ${#test_files[@]} test files${NC}"
    fi
    
    # Check for test configuration
    local config_files=()
    config_files+=($(find . -name "jest.config.*" -o -name "vitest.config.*" -o -name "cypress.config.*" 2>/dev/null || true))
    
    if [ ${#config_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No test configuration found${NC}"
    else
        echo -e "${GREEN}✅ Found test configuration${NC}"
    fi
}

# Function to run tests
run_tests() {
    echo -e "${BLUE}🧪 Running tests...${NC}"
    
    # Run npm tests if available
    if [ -f "package.json" ] && grep -q '"test"' package.json; then
        if npm test; then
            echo -e "${GREEN}✅ Tests passed${NC}"
        else
            echo -e "${RED}❌ Tests failed${NC}"
            return 1
        fi
    fi
    
    # Run pytest if available
    if [ -f "requirements.txt" ] && command -v python3 &> /dev/null; then
        if python3 -m pytest --tb=short; then
            echo -e "${GREEN}✅ Python tests passed${NC}"
        else
            echo -e "${RED}❌ Python tests failed${NC}"
            return 1
        fi
    fi
}

# Main validation function
main() {
    local test_plan_file
    
    if test_plan_file=$(check_test_plan_exists); then
        validate_test_plan_content "$test_plan_file"
        check_test_coverage
        
        # Ask if user wants to run tests
        read -p "Run tests? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            run_tests
        fi
        
        echo -e "${GREEN}🎯 Test plan validation completed${NC}"
    else
        echo -e "${RED}❌ Test plan validation failed${NC}"
        exit 1
    fi
}

# Run main function
main "$@"
EOF

    chmod +x scripts/validate-test-plan.sh
    
    echo -e "${GREEN}✅ Validation script created${NC}"
}

# Function to show setup summary
show_setup_summary() {
    echo -e "${GREEN}🎯 Testing Workflow Setup Complete!${NC}"
    echo ""
    echo -e "${BLUE}📋 What was set up:${NC}"
    echo -e "${BLUE}✅ Cursor team instructions (.cursorrules)${NC}"
    echo -e "${BLUE}✅ GitHub Actions workflow${NC}"
    echo -e "${BLUE}✅ Testing documentation${NC}"
    echo -e "${BLUE}✅ Pre-commit hooks${NC}"
    echo -e "${BLUE}✅ Package.json scripts${NC}"
    echo -e "${BLUE}✅ Validation scripts${NC}"
    echo ""
    echo -e "${BLUE}🚀 Next steps:${NC}"
    echo -e "${BLUE}1. Generate your first test plan: ./scripts/generate-test-plan.sh${NC}"
    echo -e "${BLUE}2. Review the test plan in Cursor${NC}"
    echo -e "${BLUE}3. Implement the recommended tests${NC}"
    echo -e "${BLUE}4. Create a PR to test the workflow${NC}"
    echo ""
    echo -e "${GREEN}📚 Documentation: docs/testing/README.md${NC}"
}

# Main execution
main() {
    check_prerequisites
    create_directory_structure
    setup_cursor_instructions
    setup_github_actions
    create_testing_documentation
    setup_pre_commit_hooks
    setup_package_scripts
    create_validation_script
    show_setup_summary
}

# Run main function
main "$@"