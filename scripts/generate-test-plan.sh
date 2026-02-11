#!/bin/bash

# Automated Test Plan Generation Script
# This script uses Cursor to generate comprehensive test plans

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEST_PLAN_DIR="docs/testing"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
TEST_PLAN_FILE="$TEST_PLAN_DIR/test-plan-$TIMESTAMP.md"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

echo -e "${BLUE}🚀 Automated Test Plan Generation${NC}"
echo -e "${BLUE}Timestamp: $TIMESTAMP${NC}"
echo -e "${BLUE}Branch: $CURRENT_BRANCH${NC}"

# Create testing directory
mkdir -p "$TEST_PLAN_DIR"

# Function to analyze repository structure
analyze_repository() {
    echo -e "${BLUE}🔍 Analyzing repository structure...${NC}"
    
    # Detect project type
    local project_type="Unknown"
    if [ -f "package.json" ]; then
        project_type="Node.js/JavaScript"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        project_type="Python"
    elif [ -f "Cargo.toml" ]; then
        project_type="Rust"
    elif [ -f "go.mod" ]; then
        project_type="Go"
    elif [ -f "pom.xml" ]; then
        project_type="Java/Maven"
    elif [ -f "build.gradle" ]; then
        project_type="Java/Gradle"
    elif [ -f "composer.json" ]; then
        project_type="PHP"
    elif [ -f "Gemfile" ]; then
        project_type="Ruby"
    elif [ -f "Dockerfile" ]; then
        project_type="Docker/Container"
    elif [ -f "index.html" ] && [ -d "assets" ]; then
        project_type="Static Website"
    fi
    
    echo -e "${GREEN}✅ Detected project type: $project_type${NC}"
    
    # Count files by type
    local js_files=$(find . -name "*.js" -not -path "./node_modules/*" 2>/dev/null | wc -l)
    local ts_files=$(find . -name "*.ts" -not -path "./node_modules/*" 2>/dev/null | wc -l)
    local py_files=$(find . -name "*.py" 2>/dev/null | wc -l)
    local html_files=$(find . -name "*.html" 2>/dev/null | wc -l)
    local css_files=$(find . -name "*.css" 2>/dev/null | wc -l)
    
    echo -e "${BLUE}📊 File Statistics:${NC}"
    echo -e "   JavaScript: $js_files files"
    echo -e "   TypeScript: $ts_files files"
    echo -e "   Python: $py_files files"
    echo -e "   HTML: $html_files files"
    echo -e "   CSS: $css_files files"
}

# Function to detect testing frameworks
detect_testing_frameworks() {
    echo -e "${BLUE}🧪 Detecting testing frameworks...${NC}"
    
    local frameworks=()
    
    # Check package.json for test dependencies
    if [ -f "package.json" ]; then
        if grep -q "jest" package.json; then frameworks+=("Jest"); fi
        if grep -q "mocha" package.json; then frameworks+=("Mocha"); fi
        if grep -q "cypress" package.json; then frameworks+=("Cypress"); fi
        if grep -q "playwright" package.json; then frameworks+=("Playwright"); fi
        if grep -q "vitest" package.json; then frameworks+=("Vitest"); fi
        if grep -q "testing-library" package.json; then frameworks+=("Testing Library"); fi
    fi
    
    # Check for Python testing frameworks
    if [ -f "requirements.txt" ]; then
        if grep -q "pytest" requirements.txt; then frameworks+=("pytest"); fi
        if grep -q "unittest" requirements.txt; then frameworks+=("unittest"); fi
    fi
    
    # Check for test configuration files
    if [ -f "jest.config.js" ] || [ -f "jest.config.ts" ]; then frameworks+=("Jest (configured)"); fi
    if [ -f "cypress.config.js" ] || [ -f "cypress.config.ts" ]; then frameworks+=("Cypress (configured)"); fi
    if [ -f "playwright.config.js" ] || [ -f "playwright.config.ts" ]; then frameworks+=("Playwright (configured)"); fi
    if [ -f "vitest.config.js" ] || [ -f "vitest.config.ts" ]; then frameworks+=("Vitest (configured)"); fi
    
    if [ ${#frameworks[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No testing frameworks detected${NC}"
    else
        echo -e "${GREEN}✅ Detected frameworks:${NC}"
        printf '   - %s\n' "${frameworks[@]}"
    fi
}

# Function to generate test plan template
generate_test_plan_template() {
    echo -e "${BLUE}📋 Generating test plan template...${NC}"
    
    cat > "$TEST_PLAN_FILE" << EOF
# Test Plan - $CURRENT_BRANCH

**Generated**: $(date)
**Branch**: $CURRENT_BRANCH
**Repository**: $(git remote get-url origin 2>/dev/null || echo 'Local repository')
**Last Commit**: $(git log -1 --pretty=format:'%h - %s (%an, %ar)' 2>/dev/null || echo 'No commits')

## 🎯 Executive Summary

This test plan covers comprehensive testing for the current repository. The testing strategy is organized by priority levels to ensure critical functionality is thoroughly validated while maintaining efficient test execution.

## 📊 Repository Analysis

### Project Information
- **Type**: $(detect_project_type)
- **Primary Language**: $(detect_primary_language)
- **Testing Frameworks**: $(detect_testing_frameworks | tr '\n' ', ')
- **Dependencies**: $(count_dependencies)

### File Structure
$(generate_file_structure_summary)

### Recent Changes
$(generate_recent_changes_summary)

## 🧪 Test Strategy

### A. CRITICAL TESTS (Must Pass - Priority 1)

#### Core Functionality
- [ ] **Primary Features**: Test all main application features
- [ ] **Data Flow**: Validate data processing and storage
- [ ] **User Authentication**: Test login/logout and session management
- [ ] **API Endpoints**: Validate all API responses and error handling

#### Security
- [ ] **Input Validation**: Test all user inputs for security vulnerabilities
- [ ] **Authentication**: Verify secure authentication mechanisms
- [ ] **Authorization**: Test access control and permissions
- [ ] **Data Protection**: Ensure sensitive data is properly protected

#### Performance
- [ ] **Response Times**: Validate acceptable response times
- [ ] **Load Handling**: Test under expected load conditions
- [ ] **Resource Usage**: Monitor memory and CPU usage
- [ ] **Database Performance**: Test query performance and optimization

### B. IMPORTANT TESTS (Should Pass - Priority 2)

#### Integration Testing
- [ ] **Component Integration**: Test component interactions
- [ ] **API Integration**: Test external service integrations
- [ ] **Database Integration**: Test data persistence and retrieval
- [ ] **Third-party Services**: Test external service dependencies

#### User Experience
- [ ] **UI/UX Flows**: Test complete user journeys
- [ ] **Error Handling**: Test error messages and recovery
- [ ] **Navigation**: Test all navigation paths
- [ ] **Form Validation**: Test form inputs and validation

#### Compatibility
- [ ] **Cross-browser Testing**: Test on major browsers
- [ ] **Cross-device Testing**: Test on different screen sizes
- [ ] **Cross-platform Testing**: Test on different operating systems
- [ ] **Mobile Responsiveness**: Test mobile device compatibility

### C. NICE-TO-HAVE TESTS (Could Pass - Priority 3)

#### Edge Cases
- [ ] **Boundary Conditions**: Test limits and edge values
- [ ] **Error Scenarios**: Test various error conditions
- [ ] **Stress Testing**: Test under extreme conditions
- [ ] **Concurrency**: Test concurrent user scenarios

#### Performance Optimization
- [ ] **Caching**: Test caching mechanisms
- [ ] **Compression**: Test data compression
- [ ] **CDN**: Test content delivery optimization
- [ ] **Database Optimization**: Test query optimization

## 🛠️ Test Implementation Plan

### Phase 1: Critical Tests (Week 1)
**Goal**: Ensure core functionality works correctly
**Duration**: 3-5 days
**Resources**: 1-2 developers

**Tasks**:
1. Set up testing environment
2. Create test data and fixtures
3. Implement unit tests for core functions
4. Execute integration tests
5. Perform security testing
6. Validate performance benchmarks

### Phase 2: Important Tests (Week 2)
**Goal**: Ensure good user experience and compatibility
**Duration**: 5-7 days
**Resources**: 2-3 developers

**Tasks**:
1. Implement UI/UX tests
2. Execute cross-browser testing
3. Test mobile responsiveness
4. Validate accessibility compliance
5. Test error handling scenarios

### Phase 3: Nice-to-Have Tests (Week 3+)
**Goal**: Optimize performance and handle edge cases
**Duration**: 7-10 days
**Resources**: 1-2 developers

**Tasks**:
1. Implement performance optimization tests
2. Test edge cases and boundary conditions
3. Execute stress testing
4. Optimize test execution time
5. Implement continuous testing

## 📋 Test Cases

### Unit Tests
$(generate_unit_test_cases)

### Integration Tests
$(generate_integration_test_cases)

### End-to-End Tests
$(generate_e2e_test_cases)

### Performance Tests
$(generate_performance_test_cases)

### Security Tests
$(generate_security_test_cases)

## 🎯 Success Criteria

### Coverage Targets
- **Unit Test Coverage**: 80% minimum
- **Integration Test Coverage**: 70% minimum
- **E2E Test Coverage**: 60% minimum
- **Overall Coverage**: 75% minimum

### Performance Benchmarks
- **Page Load Time**: < 3 seconds
- **API Response Time**: < 200ms
- **Database Query Time**: < 100ms
- **Memory Usage**: < 512MB

### Quality Gates
- **All Critical Tests**: Must pass
- **90% Important Tests**: Must pass
- **Security Scan**: No high/critical vulnerabilities
- **Performance**: Meets all benchmarks

## 🔧 Tools and Frameworks

### Recommended Testing Tools
$(generate_tool_recommendations)

### Test Data Management
$(generate_test_data_strategy)

### CI/CD Integration
$(generate_cicd_strategy)

## 📊 Risk Assessment

### High Risk
$(generate_high_risk_assessment)

### Medium Risk
$(generate_medium_risk_assessment)

### Mitigation Strategies
$(generate_mitigation_strategies)

## 📈 Monitoring and Maintenance

### Test Monitoring
- **Test Execution**: Monitor test run times and success rates
- **Coverage Tracking**: Track test coverage trends
- **Performance Metrics**: Monitor performance test results
- **Security Alerts**: Monitor security test results

### Test Maintenance
- **Regular Updates**: Update tests with code changes
- **Refactoring**: Refactor tests for better maintainability
- **Documentation**: Keep test documentation current
- **Training**: Train team on testing best practices

## 📝 Appendices

### A. Test Environment Setup
$(generate_environment_setup)

### B. Test Data Requirements
$(generate_test_data_requirements)

### C. Troubleshooting Guide
$(generate_troubleshooting_guide)

---

**Generated by**: Automated Test Plan Generator
**Version**: 1.0
**Last Updated**: $(date)
EOF

    echo -e "${GREEN}✅ Test plan template generated: $TEST_PLAN_FILE${NC}"
}

# Helper functions for template generation
detect_project_type() {
    if [ -f "package.json" ]; then
        echo "Node.js/JavaScript"
    elif [ -f "requirements.txt" ]; then
        echo "Python"
    elif [ -f "Cargo.toml" ]; then
        echo "Rust"
    elif [ -f "go.mod" ]; then
        echo "Go"
    elif [ -f "index.html" ]; then
        echo "Static Website"
    else
        echo "Unknown"
    fi
}

detect_primary_language() {
    local js_count=$(find . -name "*.js" -not -path "./node_modules/*" 2>/dev/null | wc -l)
    local py_count=$(find . -name "*.py" 2>/dev/null | wc -l)
    local ts_count=$(find . -name "*.ts" -not -path "./node_modules/*" 2>/dev/null | wc -l)
    
    if [ $ts_count -gt $js_count ] && [ $ts_count -gt $py_count ]; then
        echo "TypeScript"
    elif [ $js_count -gt $py_count ]; then
        echo "JavaScript"
    elif [ $py_count -gt 0 ]; then
        echo "Python"
    else
        echo "Mixed/Unknown"
    fi
}

count_dependencies() {
    if [ -f "package.json" ]; then
        local deps=$(grep -c '"dependencies"' package.json || echo "0")
        local dev_deps=$(grep -c '"devDependencies"' package.json || echo "0")
        echo "$((deps + dev_deps)) packages"
    elif [ -f "requirements.txt" ]; then
        local py_deps=$(wc -l < requirements.txt 2>/dev/null || echo "0")
        echo "$py_deps packages"
    else
        echo "Unknown"
    fi
}

generate_file_structure_summary() {
    echo "```"
    find . -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.venv/*" | head -20
    if [ $(find . -type f -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.venv/*" | wc -l) -gt 20 ]; then
        echo "... and more files"
    fi
    echo "```"
}

generate_recent_changes_summary() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "```"
        git log --oneline -10
        echo "```"
    else
        echo "No git history available"
    fi
}

generate_unit_test_cases() {
    echo "- [ ] **Function Testing**: Test all public functions and methods"
    echo "- [ ] **Input Validation**: Test all input parameters"
    echo "- [ ] **Output Validation**: Test all return values"
    echo "- [ ] **Error Handling**: Test error conditions and exceptions"
    echo "- [ ] **Edge Cases**: Test boundary conditions and limits"
}

generate_integration_test_cases() {
    echo "- [ ] **API Integration**: Test all API endpoints"
    echo "- [ ] **Database Integration**: Test data persistence"
    echo "- [ ] **Service Integration**: Test external service calls"
    echo "- [ ] **Component Integration**: Test component interactions"
}

generate_e2e_test_cases() {
    echo "- [ ] **User Workflows**: Test complete user journeys"
    echo "- [ ] **Cross-browser Testing**: Test on multiple browsers"
    echo "- [ ] **Mobile Testing**: Test on mobile devices"
    echo "- [ ] **Performance Testing**: Test under load"
}

generate_performance_test_cases() {
    echo "- [ ] **Load Testing**: Test under expected load"
    echo "- [ ] **Stress Testing**: Test under extreme load"
    echo "- [ ] **Response Time**: Test response times"
    echo "- [ ] **Memory Usage**: Test memory consumption"
}

generate_security_test_cases() {
    echo "- [ ] **Authentication**: Test login/logout security"
    echo "- [ ] **Authorization**: Test access control"
    echo "- [ ] **Input Validation**: Test for injection attacks"
    echo "- [ ] **Data Protection**: Test data encryption"
}

generate_tool_recommendations() {
    local project_type=$(detect_project_type)
    
    case $project_type in
        "Node.js/JavaScript")
            echo "- **Unit Testing**: Jest, Mocha, Vitest"
            echo "- **E2E Testing**: Cypress, Playwright"
            echo "- **API Testing**: Supertest, Postman"
            echo "- **Coverage**: Istanbul, c8"
            ;;
        "Python")
            echo "- **Unit Testing**: pytest, unittest"
            echo "- **E2E Testing**: Selenium, Playwright"
            echo "- **API Testing**: requests, httpx"
            echo "- **Coverage**: coverage.py, pytest-cov"
            ;;
        "Static Website")
            echo "- **E2E Testing**: Cypress, Playwright"
            echo "- **Performance**: Lighthouse, WebPageTest"
            echo "- **Accessibility**: axe-core, WAVE"
            echo "- **Visual**: Percy, Chromatic"
            ;;
        *)
            echo "- **General**: Choose appropriate tools for your tech stack"
            ;;
    esac
}

generate_test_data_strategy() {
    echo "- **Test Fixtures**: Create reusable test data"
    echo "- **Mock Services**: Mock external dependencies"
    echo "- **Database Seeding**: Set up test database state"
    echo "- **Environment Variables**: Configure test environments"
}

generate_cicd_strategy() {
    echo "- **Automated Testing**: Run tests on every commit"
    echo "- **Coverage Reports**: Generate and track coverage"
    echo "- **Performance Monitoring**: Monitor performance metrics"
    echo "- **Security Scanning**: Run security scans automatically"
}

generate_high_risk_assessment() {
    echo "- **Data Loss**: Risk of losing critical data during testing"
    echo "- **Security Vulnerabilities**: Risk of exposing security flaws"
    echo "- **Performance Issues**: Risk of performance degradation"
    echo "- **User Experience**: Risk of poor user experience"
}

generate_medium_risk_assessment() {
    echo "- **Test Maintenance**: Risk of tests becoming outdated"
    echo "- **False Positives**: Risk of tests failing incorrectly"
    echo "- **Resource Usage**: Risk of tests consuming too many resources"
    echo "- **Team Knowledge**: Risk of team not understanding tests"
}

generate_mitigation_strategies() {
    echo "- **Backup Strategy**: Regular backups before testing"
    echo "- **Security Review**: Regular security audits"
    echo "- **Performance Monitoring**: Continuous performance monitoring"
    echo "- **Test Documentation**: Comprehensive test documentation"
}

generate_environment_setup() {
    echo "1. **Development Environment**: Set up local development environment"
    echo "2. **Test Environment**: Create isolated test environment"
    echo "3. **Staging Environment**: Set up staging environment for integration testing"
    echo "4. **Production Environment**: Ensure production environment is ready"
}

generate_test_data_requirements() {
    echo "- **User Data**: Test user accounts and profiles"
    echo "- **Content Data**: Test content and media files"
    echo "- **Configuration Data**: Test configuration settings"
    echo "- **Mock Data**: Mock external service responses"
}

generate_troubleshooting_guide() {
    echo "- **Common Issues**: Document common test failures"
    echo "- **Debugging Steps**: Step-by-step debugging process"
    echo "- **Contact Information**: Who to contact for help"
    echo "- **Resources**: Additional documentation and resources"
}

# Function to open test plan in Cursor
open_in_cursor() {
    if command -v cursor &> /dev/null; then
        echo -e "${BLUE}📝 Opening test plan in Cursor...${NC}"
        cursor "$TEST_PLAN_FILE"
    else
        echo -e "${YELLOW}⚠️  Cursor not found. Please open the file manually:${NC}"
        echo -e "${YELLOW}   $TEST_PLAN_FILE${NC}"
    fi
}

# Function to show next steps
show_next_steps() {
    echo -e "${GREEN}🎯 Test Plan Generated Successfully!${NC}"
    echo ""
    echo -e "${BLUE}📋 Next Steps:${NC}"
    echo -e "${BLUE}1. Review the generated test plan: $TEST_PLAN_FILE${NC}"
    echo -e "${BLUE}2. Use Cursor to customize the test plan based on your specific needs${NC}"
    echo -e "${BLUE}3. Implement the recommended tests${NC}"
    echo -e "${BLUE}4. Run tests and update the plan with results${NC}"
    echo -e "${BLUE}5. Use the test plan in your PR process${NC}"
    echo ""
    echo -e "${GREEN}📁 Test Plan Location: $TEST_PLAN_FILE${NC}"
}

# Main execution
main() {
    analyze_repository
    detect_testing_frameworks
    generate_test_plan_template
    
    # Ask if user wants to open in Cursor
    read -p "Open test plan in Cursor? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        open_in_cursor
    fi
    
    show_next_steps
}

# Run main function
main "$@"