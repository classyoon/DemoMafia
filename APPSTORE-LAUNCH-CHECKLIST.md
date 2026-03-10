# Mafia Party App Store Launch Checklist (iOS)

This checklist tracks non-code launch gates that are required before App Store submission.

## 1) Access and Signing
- [ ] App Store Connect access confirmed for team `83Z22V6XMU` (Admin or App Manager).
- [ ] Xcode account login uses the same team.
- [ ] Automatic signing resolves for scheme `MafiaParty-iOS`.
- [ ] Valid iOS Distribution certificate/profile available.

## 2) App Identity and Versioning
- [ ] Bundle ID: `com.conner.yoon.mafiaparty.ios`.
- [ ] Display name: `Mafia Party`.
- [ ] Marketing version (`CFBundleShortVersionString`) set for release.
- [ ] Build number (`CFBundleVersion`) incremented for each upload.

## 3) Store Listing Metadata
- [ ] App name.
- [ ] Subtitle.
- [ ] Description.
- [ ] Keywords.
- [ ] Primary category.
- [ ] Age rating questionnaire completed.
- [ ] Support URL.
- [ ] Privacy policy URL.

## 4) Privacy, Compliance, and Legal
- [ ] App Privacy details completed in App Store Connect.
- [ ] Export compliance answered (non-exempt encryption handled).
- [ ] No missing permission usage descriptions for enabled capabilities.

## 5) Assets and Media
- [ ] App icon renders correctly in App Store Connect.
- [ ] Required iPhone screenshots uploaded.
- [ ] iPad screenshots uploaded (if shipping iPad support).

## 6) Release Validation
- [ ] iOS Debug build succeeds.
- [ ] iOS Release build succeeds.
- [ ] Archive succeeds in Xcode Organizer.
- [ ] Archive upload to App Store Connect succeeds.
- [ ] Internal TestFlight build distributed and sanity-tested.

## 7) Gameplay Smoke Tests (Real Device)
- [ ] Setup flow starts with minimum players.
- [ ] Role reveal advances to first day.
- [ ] Night actions submit and resolve.
- [ ] Day voting flow resolves and returns to night.
- [ ] Mafia win and town win both trigger correctly.

## 8) Submission
- [ ] Build assigned to App Store version.
- [ ] Release notes entered.
- [ ] Submit for review.
