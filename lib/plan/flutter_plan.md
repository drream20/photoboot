# Flutter Photo Booth Maker — Complete Project Prompt

## 1. Project Overview

Build a production-quality **Flutter mobile Photo Booth Maker** for Android and iOS.

The app lets users:

1. Open the photo booth.
2. Choose a photo-booth frame/layout.
3. Choose a countdown timer or instant capture.
4. Take the required number of photos.
5. Automatically compose the photos into the selected layout.
6. Preview the finished photo.
7. Save it to the device.
8. Share it using the native share sheet.
9. Print the finished photo.
10. Browse previously created photo-booth images locally.

The experience should feel like a real physical photo booth while remaining a polished, cute, modern mobile app.

---

# 2. Supplied Assets

Two reference images are supplied with this project.

## 2.1 App Logo

Use the supplied first image as the **primary application logo/icon**.

The logo contains a photo-booth/camera illustration with a white photo card, black photo strip, and purple/blue/pink gradient background.

Use it for:

- App icon
- Splash screen
- Home-screen branding
- Relevant empty states
- App branding

Do not unnecessarily redesign the supplied logo.

### Asset requirements

Prepare/export the logo for:

- Android launcher icon
- iOS app icon
- In-app logo
- Splash screen

Keep the original artwork crisp and preserve its visual identity.

---

## 2.2 Photo Layout Reference

Use the supplied second image as the visual reference for layouts **A–L**.

Recreate the layouts as actual selectable templates.

The templates must be implemented as configurable data rather than separate hard-coded screens.

Reference layout groups:

- A — 6x2, 3 poses
- B — 6x2, 3 poses
- C — 6x2, 4 poses
- D — 6x2, 4 poses
- E — 6x4, 4 poses
- F — 6x4, 4 poses
- G — 6x4, 3 poses
- H — 6x4, 3 poses
- I — 6x4, 2 poses
- J — 6x4, 2 poses
- K — 6x4, 2 poses
- L — 6x4, 1 pose

The exact visual proportions should follow the supplied reference image as closely as practical.

---

# 3. Design Direction

The app should feel:

- Cute
- Playful
- Modern
- Friendly
- Simple
- Polished
- Camera/photo focused

Avoid making it look like a generic enterprise utility or complicated photo editor.

Use rounded cards, soft shadows, large touch targets, subtle animation, and a purple/pink visual identity derived from the supplied logo.

---

# 4. Color System

Base the UI palette on the supplied logo.

## Primary Colors

```text
Primary Purple:   #5B21F5
Violet:           #7C2BE8
Pink:             #E52C91
Magenta:          #D326B5
White:            #FFFFFF
Charcoal:         #20232B
Soft Background:  #F8F5FF
```

## Gradient

Primary gradient direction:

```text
Purple → Violet → Magenta/Pink
```

Use gradients primarily for:

- Primary CTA buttons
- Selected layout states
- Hero areas
- Header accents
- Decorative elements

Do not use gradients everywhere.

## UI surfaces

Use:

```text
Page background: #F8F5FF
Cards:           #FFFFFF
Primary text:    #20232B
Secondary text:  muted charcoal/gray
```

Use sufficient contrast for accessibility.

---

# 5. Typography

Use a friendly, modern sans-serif font.

Prefer a bundled or platform-safe font that renders consistently on Android and iOS.

Typography hierarchy:

```text
App title:       28–34 px, bold
Screen title:    24–28 px, bold
Section title:   18–22 px, semi-bold
Body:            14–16 px
Button:          15–17 px, semi-bold/bold
Caption:         12–14 px
```

Avoid excessive text.

The photo should remain the visual focus.

---

# 6. General UI Measurements

Use responsive dimensions rather than fixed screen coordinates.

Suggested design tokens:

```text
Screen horizontal padding: 20–24 px
Card radius:                16–24 px
Button radius:              14–18 px
Small control radius:       10–14 px
Standard spacing:           8 px
Medium spacing:             16 px
Large spacing:              24 px
Extra-large spacing:        32 px
```

Minimum touch target:

```text
44 x 44 px
```

Prefer:

```text
48 x 48 px
```

for important controls.

---

# 7. App Navigation

Use a simple navigation structure.

Recommended:

```text
Home
Create
Gallery
Settings
```

For a smaller MVP, Home + Create + Gallery are sufficient, with Settings accessible from Home.

The main photo-taking workflow should not be buried behind navigation.

---

# 8. Home Screen

The Home screen should immediately communicate that this is a photo booth app.

Suggested structure:

```text
┌──────────────────────────────┐
│                              │
│           APP LOGO           │
│                              │
│        Photo Booth           │
│           Maker              │
│                              │
│  Create cute photo strips ✨ │
│                              │
│   ┌──────────────────────┐   │
│   │   ✨ TAKE PHOTOS     │   │
│   └──────────────────────┘   │
│                              │
│   Recent                     │
│   [photo] [photo] [photo]    │
│                              │
└──────────────────────────────┘
```

Primary CTA:

**TAKE PHOTOS**

Secondary:

**MY PHOTOS**

Display recent generated photos when available.

---

# 9. Layout Selection Screen

This is a core screen.

Display all templates A–L.

Suggested grid:

```text
┌────────┐ ┌────────┐ ┌────────┐
│   A    │ │   B    │ │   C    │
│ preview│ │ preview│ │ preview│
└────────┘ └────────┘ └────────┘

┌────────┐ ┌────────┐ ┌────────┐
│   D    │ │   E    │ │   F    │
│ preview│ │ preview│ │ preview│
└────────┘ └────────┘ └────────┘

┌────────┐ ┌────────┐ ┌────────┐
│   G    │ │   H    │ │   I    │
│ preview│ │ preview│ │ preview│
└────────┘ └────────┘ └────────┘

┌────────┐ ┌────────┐ ┌────────┐
│   J    │ │   K    │ │   L    │
│ preview│ │ preview│ │ preview│
└────────┘ └────────┘ └────────┘
```

Use a responsive grid that adapts to screen width.

Each card displays:

- Layout preview
- Layout letter/name
- Photo count
- Format/aspect ratio

Selected state:

- Purple/pink border
- Subtle gradient
- Checkmark
- Slight scale animation

---

# 10. Layout Definitions

## Layout A

**6x2 strip — 3 poses**

Three vertically stacked photos.

```text
┌──────────┐
│ PHOTO 1  │
├──────────┤
│ PHOTO 2  │
├──────────┤
│ PHOTO 3  │
└──────────┘
```

---

## Layout B

**6x2 strip — 3 poses**

Alternate 3-photo vertical strip styling based on the supplied reference.

---

## Layout C

**6x2 strip — 4 poses**

Four vertically stacked photos.

```text
┌──────────┐
│ PHOTO 1  │
├──────────┤
│ PHOTO 2  │
├──────────┤
│ PHOTO 3  │
├──────────┤
│ PHOTO 4  │
└──────────┘
```

---

## Layout D

**6x2 strip — 4 poses**

Alternate four-photo vertical strip design from the supplied reference.

---

## Layout E

**6x4 — 4 poses**

Landscape 2x2 photo arrangement with branding/decorative areas matching the reference.

---

## Layout F

**6x4 — 4 poses**

Alternate 2x2 landscape arrangement.

---

## Layout G

**6x4 — 3 poses**

Three-photo landscape composition.

---

## Layout H

**6x4 — 3 poses**

Three-photo landscape composition with branding/decorative region.

---

## Layout I

**6x4 — 2 poses**

Two large photos.

---

## Layout J

**6x4 — 2 poses**

Two-photo landscape strip.

---

## Layout K

**6x4 — 2 poses**

Two vertically stacked photos.

---

## Layout L

**6x4 — 1 pose**

One large photo with branding area.

---

# 11. Layout Architecture

Do not build individual screens for layouts.

Create reusable models.

Example:

```dart
class PhotoBoothLayout {
  final String id;
  final String name;
  final int photoCount;
  final double width;
  final double height;
  final List<PhotoSlot> slots;
  final LayoutOrientation orientation;
  final String? backgroundAsset;
  final BrandingConfig branding;
}
```

Photo slot:

```dart
class PhotoSlot {
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final BorderRadius borderRadius;
}
```

The coordinate system should use normalized values (0.0–1.0) or another resolution-independent system so layouts work at different output sizes.

Create a central layout registry:

```dart
final photoBoothLayouts = [
  layoutA,
  layoutB,
  layoutC,
  layoutD,
  layoutE,
  layoutF,
  layoutG,
  layoutH,
  layoutI,
  layoutJ,
  layoutK,
  layoutL,
];
```

This makes future custom layouts easy to add.

---

# 12. Timer Selection

After selecting a layout, show:

```text
Choose countdown

⚡ Instant
3 seconds
5 seconds
10 seconds
```

Default:

**3 seconds**

Also support:

**Skip timer / Instant**

When instant is selected, tapping the shutter captures immediately.

Use large selectable cards.

---

# 13. Photo Session Flow

Main flow:

```text
HOME
  ↓
CHOOSE LAYOUT
  ↓
CHOOSE TIMER
  ↓
REQUEST CAMERA PERMISSION IF NEEDED
  ↓
CAMERA
  ↓
COUNTDOWN
  ↓
CAPTURE
  ↓
NEXT PHOTO
  ↓
REPEAT UNTIL COMPLETE
  ↓
PHOTO REVIEW
  ↓
COMPOSE FINAL IMAGE
  ↓
RESULT
  ↓
SAVE / SHARE / PRINT
```

---

# 14. Camera Screen

Use Flutter's camera functionality.

The camera screen should be simple and immersive.

Suggested structure:

```text
┌─────────────────────────────┐
│  ×                    🔄    │
│                             │
│                             │
│        CAMERA VIEW          │
│                             │
│            3                │
│                             │
│                             │
│             ●               │
│                             │
│          ● ● ○ ○            │
└─────────────────────────────┘
```

Features:

- Front/back camera switch
- Flash toggle where supported
- Countdown
- Large capture button
- Photo progress
- Cancel
- Current photo number
- Total required photos

Example:

```text
Photo 2 of 4
```

---

# 15. Countdown Animation

For timed capture:

```text
3
↓
2
↓
1
↓
FLASH
↓
PHOTO
```

Use a large animated number.

Suggested animation:

- Scale in
- Slight fade
- Scale out

Each number should be highly visible.

For instant capture, bypass the countdown.

---

# 16. Automatic Multi-Photo Capture

If the layout requires four photos:

```text
Photo 1
  ↓
Countdown
  ↓
Capture
  ↓
Photo 2
  ↓
Countdown
  ↓
Capture
  ↓
Photo 3
  ↓
Countdown
  ↓
Capture
  ↓
Photo 4
  ↓
Generate result
```

The user should not need to manually press "Next" after every successful capture.

Display progress:

```text
● ○ ○ ○
```

then:

```text
● ● ○ ○
```

then:

```text
● ● ● ○
```

then:

```text
● ● ● ●
```

---

# 17. Photo Review

After all required photos have been captured:

```text
Looking good! ✨

┌─────────────────────┐
│                     │
│    FINAL PREVIEW    │
│                     │
└─────────────────────┘

[ RETAKE ]   [ USE PHOTOS ]
```

MVP:

- Retake entire session
- Continue

Architecture should allow individual photo retakes later.

---

# 18. Photo Composition Engine

Create the final output image programmatically.

Do not rely solely on a widget screenshot.

Create a reusable service:

```dart
class PhotoComposer {
  Future<File> composePhotoBooth({
    required PhotoBoothLayout layout,
    required List<File> photos,
  });
}
```

Composition steps:

1. Create output canvas.
2. Load selected layout.
3. Load captured photos.
4. Crop each photo to its slot.
5. Scale photos correctly.
6. Preserve natural proportions.
7. Apply rounded corners where specified.
8. Draw borders/background.
9. Add branding.
10. Add decorative elements.
11. Export final PNG/JPEG.
12. Save to app storage.

Use the Flutter `image` package or another appropriate image-processing solution.

---

# 19. Output Sizes

Support high-quality output.

### Vertical strip layouts

Reference format:

```text
6 x 2
```

Use a high-resolution pixel representation for export, for example:

```text
1200 x 3600 px
```

or another equivalent 3:1 high-resolution canvas.

### Landscape layouts

Reference format:

```text
6 x 4
```

Use a high-resolution pixel representation such as:

```text
1800 x 1200 px
```

or another equivalent 3:2 high-resolution canvas.

The exact output resolution can be configurable, but the aspect ratio must remain correct.

Do not stretch images.

---

# 20. Photo Cropping

Each photo slot should use a cover/crop strategy.

Conceptually:

```text
Original Photo
      ↓
Determine slot ratio
      ↓
Crop to cover slot
      ↓
Scale to slot
      ↓
Render
```

Never stretch faces or people.

The system should support camera images with different aspect ratios.

---

# 21. Branding System

Layouts should support optional branding.

Examples:

```text
Photo Booth ✨
```

or:

```text
Sarah & John
Wedding Day
September 2026
```

For MVP, branding can be fixed or optional.

Create a configurable model:

```dart
class BrandingConfig {
  final bool enabled;
  final String? title;
  final String? subtitle;
  final String? logoAsset;
}
```

Future customization can include:

- Event name
- Date
- Font
- Text color
- Logo
- Position

---

# 22. Final Result Screen

After composition:

```text
Your photo is ready! ✨

        ┌──────────────┐
        │              │
        │ FINAL PHOTO  │
        │              │
        └──────────────┘

      [ 💾 SAVE ]

      [ ↗ SHARE ]

      [ 🖨 PRINT ]

      [ 📸 NEW PHOTO ]
```

The final image should be displayed prominently.

Buttons must be large and easy to use.

---

# 23. Save to Device

When the user taps Save:

1. Generate final image if not already generated.
2. Save it to an appropriate app/gallery-accessible location.
3. Handle permissions.
4. Show success feedback.

Example:

```text
✨ Saved to your photos!
```

Do not permanently store unnecessary intermediate images.

---

# 24. Sharing

Use native OS sharing.

Recommended package:

```text
share_plus
```

The user should be able to share through installed apps such as:

- Messages
- WhatsApp
- Instagram
- Facebook
- Email
- AirDrop
- Other compatible applications

Share the final generated image.

If sharing fails, return gracefully to the result screen.

---

# 25. Printing

Add a Print button.

Recommended package:

```text
printing
```

Requirements:

- Native printer selection
- Print preview
- Standard printer support
- Graceful handling when no printer is available
- Use the final high-resolution composition

Do not crash if printing is unavailable.

---

# 26. Gallery

Create a local gallery.

Example:

```text
My Photo Booth

┌────────┐ ┌────────┐
│ photo  │ │ photo  │
└────────┘ └────────┘

┌────────┐ ┌────────┐
│ photo  │ │ photo  │
└────────┘ └────────┘
```

Tap an image to open:

```text
Preview

[ SHARE ]
[ PRINT ]
[ DELETE ]
```

Only final generated photos need to appear in the gallery.

---

# 27. Local Storage

Use **Hive** for lightweight local metadata.

Recommended packages:

```text
hive
hive_flutter
path_provider
path
```

Store metadata such as:

```dart
@HiveType(typeId: 0)
class PhotoSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  String layoutId;

  @HiveField(3)
  int timerSeconds;

  @HiveField(4)
  String outputPath;
}
```

Do NOT store large image binaries inside Hive unless there is a strong reason.

Use:

```text
Hive
  ↓
metadata + file paths

Application/Documents storage
  ↓
actual images
```

This keeps the database lightweight.

---

# 28. Local-First Architecture

The basic photo booth experience must work without an account and without internet.

Core workflow:

```text
Camera
  ↓
Photos
  ↓
Local composition
  ↓
Local storage
  ↓
Save / Share / Print
```

Do not make cloud services a requirement for the MVP.

---

# 29. Suggested Flutter Packages

Use current stable versions compatible with the selected Flutter SDK.

Suggested dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter

  camera:
  hive:
  hive_flutter:
  path_provider:
  path:
  image:
  share_plus:
  printing:
  permission_handler:
  uuid:
```

Potentially:

```text
photo_manager
```

if direct device-gallery integration is needed.

Do not blindly copy old package versions. Select versions compatible with the current Flutter/Dart environment.

---

# 30. Recommended Project Structure

Use clean, feature-oriented architecture.

```text
lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── app_text_styles.dart
│   │
│   └── routes/
│
├── core/
│   ├── services/
│   │   ├── camera_service.dart
│   │   ├── photo_composer.dart
│   │   ├── storage_service.dart
│   │   ├── share_service.dart
│   │   └── print_service.dart
│   │
│   └── utils/
│
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │
│   ├── layouts/
│   │   ├── layout_selection_screen.dart
│   │   ├── layout_model.dart
│   │   ├── layout_repository.dart
│   │   └── widgets/
│   │
│   ├── camera/
│   │   ├── camera_screen.dart
│   │   ├── camera_controller.dart
│   │   └── widgets/
│   │
│   ├── result/
│   │   ├── result_screen.dart
│   │   └── widgets/
│   │
│   ├── gallery/
│   │   ├── gallery_screen.dart
│   │   └── gallery_controller.dart
│   │
│   └── settings/
│
├── models/
│   └── photo_session.dart
│
└── assets/
    ├── branding/
    │   └── app_logo.png
    │
    └── layouts/
        ├── layout_a.png
        ├── layout_b.png
        ├── layout_c.png
        ├── layout_d.png
        ├── layout_e.png
        ├── layout_f.png
        ├── layout_g.png
        ├── layout_h.png
        ├── layout_i.png
        ├── layout_j.png
        ├── layout_k.png
        └── layout_l.png
```

---

# 31. State Management

Use a clean and maintainable state-management approach.

The implementation may use a lightweight approach such as:

- ChangeNotifier
- ValueNotifier
- Riverpod
- Bloc/Cubit

Do not introduce unnecessary complexity.

The important requirement is that camera/session state remains separate from presentation.

The photo session should have clear states such as:

```text
idle
selectingLayout
selectingTimer
initializingCamera
countdown
capturing
review
composing
completed
error
```

---

# 32. Camera Session Model

Create a session model similar to:

```dart
class PhotoBoothSession {
  final String id;
  final PhotoBoothLayout layout;
  final int timerSeconds;
  final List<File> capturedPhotos;
  final int currentPhotoIndex;
}
```

The camera workflow should know:

```text
required photos = layout.photoCount
```

rather than hard-coding the number of photos.

---

# 33. Permissions

Handle permissions only when required.

Camera:

```text
User taps TAKE PHOTOS
        ↓
Check camera permission
        ↓
Request if needed
        ↓
Open camera
```

For gallery/save functionality, request the appropriate platform permissions only when necessary.

Handle:

- Granted
- Denied
- Permanently denied
- Restricted/unavailable

For permanently denied permissions, provide a clear route to system settings.

---

# 34. Responsive Design

The app must work on:

- Small Android phones
- Large Android phones
- Small iPhones
- Large iPhones

Do not hard-code screen sizes.

Use:

```dart
MediaQuery
LayoutBuilder
Flexible
Expanded
AspectRatio
SafeArea
```

Photo previews must preserve the actual output aspect ratio.

Respect:

- Safe areas
- Notches
- Dynamic island
- System navigation areas
- Orientation constraints

---

# 35. Accessibility

Include:

- Sufficient color contrast
- Semantic labels for important controls
- Large touch targets
- Buttons that are readable without relying only on icons
- Clear error messages
- No critical information communicated only by color

Example:

Do not use only a purple border to indicate selection. Also show a checkmark or text.

---

# 36. Animations

Use subtle, fast animations.

Suggested duration:

```text
200–400 ms
```

Examples:

### Layout selection

```text
scale 1.00 → 1.03
```

### Countdown

Large number:

```text
fade + scale
```

### Capture

Brief camera-flash animation.

### Result

Subtle reveal/scale animation.

Avoid excessive animations that interfere with photography.

---

# 37. Error Handling

Handle all important failures gracefully.

## Camera unavailable

```text
Camera unavailable.
Please check your camera permissions.
```

## Permission denied

```text
Camera access is required to take photos.
```

Provide a settings button where appropriate.

## Storage failure

```text
We couldn't save your photo.
Please check available storage.
```

## Printing unavailable

```text
No compatible printer is available.
```

Do not crash.

## Share failure

Return to the result screen and show a short error message.

---

# 38. Settings

A simple Settings screen can include:

```text
Settings

Default timer
[ 3 seconds ]

Save quality
[ High ]

Show date on photos
[ ON ]

Default camera
[ Front ]

About
```

Keep the MVP settings lightweight.

Future settings can include:

- Default layout
- Branding
- Default filter
- Custom event name
- Sound effects
- Haptic feedback

---

# 39. Future Features

Design the architecture so these can be added later without rewriting the core photo workflow.

## Custom Frames

Allow users to design their own layout.

## Event Mode

Templates:

```text
Wedding
Birthday
Graduation
Party
Corporate
Baby Shower
Holiday
```

## Custom Text

Examples:

```text
Sarah & John
Wedding Day
September 2026
```

## Stickers

Examples:

```text
Hearts
Stars
Flowers
Confetti
Crowns
Party icons
```

## Filters

```text
Original
Warm
Cool
Vintage
Black & White
Film
```

## Custom Backgrounds

Support:

```text
Solid color
Gradient
Pattern
Image
```

## QR Code

Generate:

```text
Scan to download
```

## Online Event Gallery

Possible future backend feature.

Do not make this part of the MVP.

---

# 40. User Experience Principles

Always prioritize:

1. Taking photos quickly.
2. Minimal user decisions.
3. Large obvious controls.
4. Beautiful previews.
5. Reliable saving.
6. Reliable sharing.
7. Reliable printing.

A user should be able to start a photo session within a few seconds of opening the app.

Avoid unnecessary onboarding screens.

---

# 41. Complete User Flow

```text
┌─────────────────────────────┐
│            HOME             │
│                             │
│          APP LOGO           │
│       Photo Booth Maker     │
│                             │
│       TAKE PHOTOS ✨        │
│                             │
│       Recent Photos         │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       CHOOSE LAYOUT         │
│                             │
│  A   B   C                  │
│  D   E   F                  │
│  G   H   I                  │
│  J   K   L                  │
│                             │
│        CONTINUE             │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       CHOOSE TIMER          │
│                             │
│  ⚡ Instant                 │
│  3 seconds                  │
│  5 seconds                  │
│  10 seconds                 │
│                             │
│        START                │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│          CAMERA             │
│                             │
│       CAMERA PREVIEW        │
│                             │
│             3               │
│                             │
│             ●               │
│                             │
│          ● ○ ○ ○            │
└──────────────┬──────────────┘
               │
               ▼
        Capture all photos
               │
               ▼
┌─────────────────────────────┐
│         REVIEW              │
│                             │
│       FINAL PREVIEW         │
│                             │
│   RETAKE     USE PHOTOS     │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       YOUR PHOTO ✨         │
│                             │
│       FINAL IMAGE           │
│                             │
│        SAVE                 │
│        SHARE                │
│        PRINT                │
│        NEW PHOTO            │
└─────────────────────────────┘
```

---

# 42. MVP Acceptance Criteria

The MVP is complete when a new user can:

1. Open the app.
2. See the supplied logo.
3. Tap **TAKE PHOTOS**.
4. Choose any layout A–L.
5. Choose Instant, 3 sec, 5 sec, or 10 sec.
6. Grant camera permission.
7. Use the camera.
8. Automatically capture the required number of photos.
9. See photo progress.
10. Review the resulting composition.
11. Generate a high-quality final image.
12. Save the image.
13. Share the image.
14. Print the image.
15. Find the saved image in the app's local gallery.
16. Delete old generated images.
17. Restart and use the app again without an account or internet connection.

---

# 43. Technical Quality Requirements

The implementation must:

- Follow modern Flutter conventions.
- Avoid unnecessary global state.
- Separate UI from business logic.
- Keep photo composition in a service.
- Keep camera functionality in a service/controller.
- Keep storage operations in a service.
- Keep sharing/printing separate from UI.
- Use strongly typed models.
- Use null-safe Dart.
- Avoid duplicated layout logic.
- Avoid hard-coded screen dimensions.
- Handle lifecycle changes for the camera.
- Dispose camera controllers correctly.
- Handle errors gracefully.
- Avoid memory leaks.
- Avoid keeping unnecessary full-resolution images in memory.
- Keep Hive metadata small.
- Preserve output image quality.

---

# 44. Performance Requirements

Photo processing can be memory intensive.

Therefore:

- Dispose camera resources correctly.
- Avoid loading all full-resolution images repeatedly.
- Process images sequentially where practical.
- Resize only when necessary.
- Cache thumbnails separately from final images.
- Use background/isolate processing if composition becomes expensive.
- Never block the UI thread unnecessarily.
- Show a loading state while generating the final image.

During composition show:

```text
Creating your photo... ✨
```

instead of leaving the screen frozen.

---

# 45. Asset Organization

Keep assets organized:

```text
assets/
├── branding/
│   ├── app_logo.png
│   └── app_logo_small.png
│
├── layouts/
│   ├── layout_a.png
│   ├── layout_b.png
│   ├── layout_c.png
│   ├── layout_d.png
│   ├── layout_e.png
│   ├── layout_f.png
│   ├── layout_g.png
│   ├── layout_h.png
│   ├── layout_i.png
│   ├── layout_j.png
│   ├── layout_k.png
│   └── layout_l.png
│
└── decorative/
    ├── hearts.png
    ├── stars.png
    └── confetti.png
```

Only include decorative assets if actually needed.

---

# 46. App Icon and Splash

The supplied logo should be the basis of the app icon.

The splash screen should be minimal:

```text
        [LOGO]

   Photo Booth Maker
```

Use the brand gradient subtly.

Avoid an overly long splash animation.

---

# 47. Final Product Personality

The finished app should communicate:

> "Open it, pick a cute frame, pose, and get your photo."

It should not feel like a professional photo-editing application.

The core interaction should be:

```text
Pick frame
    ↓
Pick timer
    ↓
Pose
    ↓
📸
    ↓
Beautiful photo
```

Keep the experience delightful and fast.

---

# 48. Final Developer Instruction

**Build the application as a real, functional Flutter app rather than a static UI prototype.**

Use the supplied first image as the application's logo and visual identity.

Use the supplied second image as the reference for layouts A–L.

Implement:

- Responsive UI
- Cute purple/pink branding
- Layout selection
- Timer selection
- Real camera capture
- Multi-photo sessions
- Countdown
- Photo composition
- High-resolution export
- Save
- Native sharing
- Printing
- Local gallery
- Hive metadata storage
- Permissions
- Error handling
- Clean architecture

The architecture must be extensible enough to support future custom frames, filters, stickers, event branding, QR codes, and online galleries.

**The most important requirement is a complete working end-to-end photo booth flow.**
