# Cursor Test Plan Generation Prompt

## 🎯 Universal Prompt for Repository Test Plan Generation

Use this prompt template with Cursor to generate comprehensive test plans for any repository. This prompt is designed to work across different project types, technologies, and architectures.

---

## 📋 **MAIN PROMPT**

```
Please analyze this entire repository and create a comprehensive test plan. Follow these steps:

### 1. REPOSITORY ANALYSIS
- **Project Type**: Identify the project type (web app, API, mobile app, library, etc.)
- **Tech Stack**: List all technologies, frameworks, and dependencies used
- **Architecture**: Describe the overall architecture and key components
- **Entry Points**: Identify main entry points, routes, and user flows
- **Dependencies**: List external dependencies and integrations

### 2. TEST STRATEGY FRAMEWORK
Create test plans for these categories:

#### A. FUNCTIONAL TESTING
- **Unit Tests**: Test individual functions, methods, and components
- **Integration Tests**: Test component interactions and API endpoints
- **End-to-End Tests**: Test complete user workflows
- **API Tests**: Test all endpoints, request/response validation
- **UI/UX Tests**: Test user interface and user experience flows

#### B. NON-FUNCTIONAL TESTING
- **Performance Tests**: Load testing, stress testing, response times
- **Security Tests**: Authentication, authorization, data protection
- **Compatibility Tests**: Cross-browser, cross-device, cross-platform
- **Accessibility Tests**: WCAG compliance, screen reader compatibility
- **Usability Tests**: User experience, navigation, error handling

#### C. INFRASTRUCTURE & DEPLOYMENT TESTS
- **Environment Tests**: Development, staging, production environments
- **Deployment Tests**: CI/CD pipeline, build processes
- **Configuration Tests**: Environment variables, configuration files
- **Database Tests**: Data integrity, migrations, backups

### 3. TEST IMPLEMENTATION PLAN
For each test category, provide:
- **Test Cases**: Specific test scenarios with steps
- **Test Data**: Required test data and fixtures
- **Tools & Frameworks**: Recommended testing tools
- **Automation Strategy**: What to automate vs manual testing
- **Priority Levels**: Critical, High, Medium, Low priority tests

### 4. TESTING ENVIRONMENT SETUP
- **Prerequisites**: Required tools, accounts, permissions
- **Test Environment**: Setup instructions for test environments
- **Data Setup**: How to prepare test data
- **Mock Services**: External service mocking strategies

### 5. EXECUTION TIMELINE
- **Phase 1**: Critical functionality tests (immediate)
- **Phase 2**: Core feature tests (short-term)
- **Phase 3**: Edge cases and integration tests (medium-term)
- **Phase 4**: Performance and security tests (long-term)

### 6. SUCCESS CRITERIA
- **Coverage Targets**: Minimum test coverage percentages
- **Performance Benchmarks**: Acceptable response times, load limits
- **Quality Gates**: Criteria for release approval
- **Regression Prevention**: Strategies to prevent regressions

### 7. MAINTENANCE & MONITORING
- **Test Maintenance**: How to keep tests updated
- **Continuous Testing**: Integration with CI/CD
- **Monitoring**: Production monitoring and alerting
- **Reporting**: Test reporting and metrics

## OUTPUT FORMAT
Structure your response as:
1. **Executive Summary** (2-3 paragraphs)
2. **Detailed Test Plans** (organized by category)
3. **Implementation Roadmap** (timeline and priorities)
4. **Resource Requirements** (tools, time, team)
5. **Risk Assessment** (testing risks and mitigation)

Focus on actionable, specific test cases that can be immediately implemented. Prioritize tests based on business impact and technical risk.
```

---

## 🔧 **CUSTOMIZATION GUIDELINES**

### For Different Project Types:

#### **Web Applications**
- Add browser compatibility testing
- Include responsive design testing
- Focus on user journey testing
- Add SEO and performance testing

#### **APIs/Microservices**
- Emphasize API contract testing
- Include load and stress testing
- Add security and authentication testing
- Focus on data validation testing

#### **Mobile Applications**
- Add device-specific testing
- Include app store compliance testing
- Focus on offline/online scenarios
- Add battery and performance testing

#### **Libraries/Packages**
- Focus on API compatibility testing
- Include version compatibility testing
- Add documentation accuracy testing
- Emphasize edge case testing

### For Different Technologies:

#### **Frontend (React, Vue, Angular)**
- Component testing
- State management testing
- Routing testing
- UI/UX testing

#### **Backend (Node.js, Python, Java)**
- Business logic testing
- Database testing
- API endpoint testing
- Error handling testing

#### **Databases**
- Data integrity testing
- Query performance testing
- Migration testing
- Backup/recovery testing

---

## 📊 **EXAMPLE USAGE**

### Basic Usage:
```
[Copy the main prompt above and paste into Cursor]
```

### With Specific Focus:
```
[Main prompt] + "Focus specifically on [security testing/performance testing/accessibility testing] and provide detailed test cases for [specific feature/component]."
```

### For Legacy Code:
```
[Main prompt] + "This is legacy code with limited documentation. Focus on critical path testing and provide strategies for safely refactoring while maintaining functionality."
```

### For New Projects:
```
[Main prompt] + "This is a new project in early development. Focus on establishing testing foundations and provide guidance for test-driven development practices."
```

---

## 🎯 **BEST PRACTICES**

1. **Always start with the main prompt** - it's comprehensive and covers all aspects
2. **Customize based on project type** - use the guidelines above
3. **Be specific about priorities** - mention what's most critical for your project
4. **Ask for examples** - request specific test case examples for complex features
5. **Request automation guidance** - ask for specific tools and frameworks recommendations
6. **Follow up with implementation** - ask for step-by-step implementation guides

---

## 📈 **EXPECTED OUTCOMES**

Using this prompt should give you:
- ✅ Comprehensive test coverage plan
- ✅ Specific, actionable test cases
- ✅ Tool and framework recommendations
- ✅ Implementation timeline
- ✅ Resource requirements
- ✅ Risk assessment and mitigation strategies

---

*This prompt template is designed to work with any repository type and can be reused across different projects. Simply copy, paste, and customize based on your specific needs.*