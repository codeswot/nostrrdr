# Default recipe - show available commands
default:
    @just --list

build_runner:
	dart run build_runner build --delete-conflicting-outputs
	

# Pre-commit checks: run the same checks as CI locally
precommit:
    just deps-flutter    
    just fix
    just format
    just lint
    just test-flutter    
    @echo "✅ All pre-commit checks passed!"

deps-flutter:
    @echo "📦 Installing Flutter dependencies..."
    flutter pub get

# Run Flutter analyzer
analyze:
    @echo "🔍 Running Flutter analyzer..."
    flutter analyze --fatal-infos

# Format Dart code
format-dart:
    @echo "💅 Formatting Dart code..."
    dart format lib/ integration_test/

# Check Dart code formatting (CI-style check)
check-dart-format:
    @echo "🔍 Checking Dart code formatting..."
    dart format --set-exit-if-changed lib/ integration_test/

# Test Flutter code
test-flutter:
    @echo "🧪 Testing Flutter code..."
    @if [ -d "test" ]; then flutter test; else echo "No test directory found. Create tests in test/ directory."; fi

# Test Flutter code with coverage and check diff coverage
check-flutter-coverage:
    @echo "🧪 Testing Flutter code with coverage..."
    flutter test --coverage
    @echo "📊 Checking coverage for changed files..."
    ./scripts/check_diff_coverage.sh

# Format code
format: format-dart

# Lint code 
lint: analyze

# Fix common issues
fix:
    @echo "🔧 Fixing common issues..."    
    dart fix --apply

# Show project info and status
info:
    @echo "📊 Nostrrdr Project Info"
    @echo "Flutter version:"
    @flutter --version
    @echo ""
    @echo "Project dependencies status:"
    @echo "- Flutter deps:"
    @flutter pub deps --no-dev | head -10
