# Skill: UI Implementation from Stitch

This skill guides the agent in converting Stitch design metadata into production-ready Flutter code.

## Protocol

1.  **Analyze Design**: Pull the latest design tokens and component specs from the Stitch MCP server.
2.  **Map to Theme**: Ensure all colors, typography, and spacing map to `lib/core/theme/app_theme.dart`.
3.  **Generate Widgets**:
    - Use `ScreenUtil` for responsive sizing.
    - Follow the Atomic Design pattern (atoms in `lib/core/widgets`, organisms in feature directories).
    - Implement navigation using `GoRouter`.
4.  **State Management**: Use `Riverpod` or `ChangeNotifier` (as established in `auth_service.dart`) for business logic.
5.  **Verify**: Run `flutter analyze` after every component creation.

## Example Prompt
"Apply the 'Patient Profile' design from Stitch to a new feature directory."
