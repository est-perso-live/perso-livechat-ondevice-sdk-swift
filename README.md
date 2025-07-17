<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/banner_dark.png" />
  <source media="(prefers-color-scheme: light)" srcset=".github/banner_light.png" />
  <img style="width:100%;" alt="PERSO.ai Banner" src=".github/banner_light.png" />
</picture>

<div align="center">

# [PERSO.ai](https://perso.ai/) LiveChat On-Device SDK for Swift

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange?style=flat-square)](https://img.shields.io/badge/Swift-6.0+-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-macOS-Green?style=flat-square)](https://img.shields.io/badge/Platforms-macOS-Green?style=flat-square)

<p align="center"> 📕 <a href="https://github.com/est-perso-live/perso-livechat-ondevice-sdk-swift/releases/latest">Documentation</a> &nbsp | &nbsp 📱 <a href="https://github.com/est-perso-live/perso-livechat-ondevice-sample-swift">Sample Project</a>
</div>

<br>

The [PERSO.ai](https://perso.ai/) LiveChat SDK is the next-generation universal interface for conversational AI.
It supports real-time communication and personalized interactions with over 100 languages, featuring natural speech-to-text conversion and lifelike AI Human expressions.

<br/>

## Prerequisites

The PERSO.ai LiveChat SDK supports :
* macOS 15.0 or later
* Xcode 16.0 or later
* Swift 6.0 or later

<br/>
 
## Installation
### Swift Package Manager

To install the PERSO.ai LiveChat SDK, follow these steps:

1. Open your Xcode project.
2. Navigate to `File` > `Add Package Dependencies...`.
3. Enter the package repository URL: `https://github.com/est-perso-live/perso-livechat-ondevice-sdk-swift`.
4. Choose the version range or specific version.
5. Click `Add Package` to add PersoLiveChatOnDeviceSDK to your project

<br/>

Once this setup is complete, you can `import PersoLiveChatOnDeviceSDK` and start using the SDK in your Swift code.

<br/>

## After installation
### Microphone Permission
The SDK includes features that may require microphone access. However, microphone permission is optional and will only be requested if microphone-dependent features are used (e.g., voice chat).

To ensure proper functionality for these features, include the following permission key in your app's Info.plist file:

| Key                                      | Value (Example)                                              |
|------------------------------------------|--------------------------------------------------------------|
| `Privacy - Microphone Usage Description` | This app requires microphone access for voice chat features. |

<br/>

## Usage
### Step 1. Import the SDK
Import the SDK where you need to use it.

```swift
import PersoLiveChatOnDeviceSDK
```
  
<br/>

### Step 2. Initialize
#### Using API Key

If you choose to use an API Key, you must set it with **top priority** before any SDK feature is used.

```swift
PersoLiveChat.apiKey = "YOUR_API_KEY"
```

> [!CAUTION]  
> **The PERSO.ai LiveChat SDK for Swift is not recommended to embed an API Key directly in your app.**
> There's a high risk that malicious actors could discover and misuse your API Key.
> We strongly recommend using a SessionID issued by your backend whenever possible, rather than exposing your API Key.

<br/>

#### Using Session ID

When you have a server-issued SessionID, you do not need to configure an API Key.
Your app only needs the assigned SessionID to establish a connection with the SDK, greatly reducing any risk of API Key exposure.

Skip API Key setup.

<br/>

### Step 3. Load AI Human
To use `PersoLiveChat`, AI human model information must be registered in the system.

The process of retrieving the registered model style information is required first.


#### Fetch Model Styles

The list of available model styles can be retrieved using the following method:

```swift
let styles = try await PersoLiveChat.fetchAvailableModelStyles()
```

This method does more than simply return a list of styles.  
It also provides metadata for each style, including the availability and status of its associated model resources.  
This allows the app to make informed decisions about whether a style is ready for use or needs to be downloaded.

#### Load Model Style

Asynchronously downloads and prepares all model resources required for the specified `ModelStyle`.

Resources are downloaded concurrently, and progress updates are emitted through `AsyncThrowingStream<Progress, Error>`,  
allowing you to observe download progress in real time and handle errors gracefully:

```swift
do {
    let stream = PersoLiveChat.loadModelStyle(with: ModelStyle)

    for try await progress in stream {
        // handle progress
    }
} catch {
    // handle error
}
```

Downloads are performed only if there are changes or updates to the resources.
If the server responds with `.notModified`, the existing cached version is used instead of re-downloading.
This reduces unnecessary network usage and improves overall performance.

#### Clean Model Resources
Removes files and resets internal tracking information related to model styles.

```swift
PersoLiveChat.cleanModelResources()
```

<br/>

### Step 4. Load Inference Model
Before using any `PersoLiveChat` features, you must load and initialize the models required for inference with a specific model style.
This process requires model resources, which must be downloaded beforehand to ensure proper initialization.

If the initialization method is not called, errors may occur during prediction.

```swift
try await PersoLiveChat.load(ModelStyle)
```

<br/>

#### Warmup Feature for Performance Optimization
This project offers a model warmup feature to optimize initial prediction performance. By using this feature, the time required for predictions during the first call of PersoLive is reduced, allowing users to experience faster response times.

Key Features:
* **Model Warmup**: Loads and initializes the model at the start of the application, minimizing potential delays when users make their first prediction request.  
* **Reduced Initial Prediction Time**: Utilizes the pre-warmed model to handle the first prediction request in PersoLive more swiftly.
By using this feature, you can enhance the application's responsiveness and improve the overall user experience.

It is recommended to call this at an early stage, before starting `PersoVideoView`.
```swift
await PersoLiveChat.warmup()
```

<br/>

### Step 5. Set Audio Session
> **Note:** `AVAudioSession` is only available on `iOS` and `visionOS`. For `macOS`, no audio session setup is required.

PersoLiveChat uses `AVAudioSession` to perform voice-related functions. It is essential to set up `AVAudioSession` before starting `PersoVideoView`.  

```swift
func setAudioSession(
    category: AVAudioSession.Category,
    mode: AVAudioSession.Mode = .default,
    policy: AVAudioSession.RouteSharingPolicy = .default,
    options: AVAudioSession.CategoryOptions = []
) throws
```

<br/>

If the `AVAudioSession` fails to be configured or activated, the `PersoLiveChatError.audioSessionSetupError` will be thrown. Make sure to handle errors properly to prevent unexpected crashes or issues.

Example:
```swift
do {
    try PersoLiveChat.setAudioSession(
        category: .playAndRecord,
        options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP]
    )
} catch {
    print("Failed to set up audio session: \(error)")
}

// After setting the audio session, start PersoVideoView.
```
> The appropriate `AVAudioSession.Category` and `AVAudioSession.CategoryOptions` should be configured based on your specific use case.  
> 
> For more detailed information about categories, options, and other related topics, please refer to the [AVAudioSession SetCategory](https://developer.apple.com/documentation/avfaudio/avaudiosession/2887480-setcategory) documentation

<br />

### Step 6. Feature Models
#### Using API Key
Before creating a session, it is necessary to define which features will be used to create the session.
It is essential to first obtain the model information available for each feature in STT, LLM, and TTS.

```swift
// Obtain usable STT Model information.
try await PersoLiveChat.fetchAvailableSTTModels()

// Obtain usable prompts information.
try await PersoLiveChat.fetchAvailablePrompts()

...
...
...
```

Not everything can be demonstrated in the example, so please refer to the specifications for the required features.

When using a SessionID, it is not necessary to use it.

<br/>

### Step 7. Session
#### Create Using API Key

You must first be assigned a `SessionID` before using the features. Add the feature you want to use and include the necessary configuration information.


```swift
do {
    session = try await PersoLiveChat.createSession(
        for: [
            .speechToText(type: STTType),
            .largeLanguageModel(
                llmType: LLMType,
                promptType: Prompt?,
                documentType: Document?
            ),
            .textToSpeech(type: TTSType)
        ],
        modelStyle: ModelStyle
    ) { status in

    // session status handler

    }
} catch {
    // handle session create error
}
```

<br/>

#### Connect Using Session ID
It can be used if a `SessionID` has already been assigned. 
Within the SDK, the validity of the `SessionID` is checked, and if it is valid, a session can be assigned.
```swift

do {
    session = try await PersoLiveChat.connectSession(
        sessionID: "assigned SessionID",
        modelStyle: ModelStyle
    ) { status in

    // session status handler

    }
} catch {
    // handle session create error
}
```

<br/>

#### Stop the Session
When you're done with the session and want to end it, you can use the `stopSession()` method:

```swift 
PersoLiveChat.stopSession()
```

This method ends the current session if one exists. It's useful when the user closes the livechat interface. After calling this method, the current session object becomes invalid, and you'll need to create a new session or connect to an existing one to start a new chat.   

<br/>

You can also listen to the session status handler to respond to session termination events:
```swift
session = try await PersoLiveChat.createSession(
    for: [
        .speechToText(type: STTType)
    ],
    modelStyle: ModelStyle
) { status in
    switch status {
    case .started:
        print("Start Session")
    case .terminated:
        print("Session has been terminated.")
        // Update UI or take other actions
    }
}
```

<br/>

### Step 8. Displaying the AI Human on Screen
You can control how the video content is displayed on the screen by configuring the `videoContentMode` and `offsetY` properties of `PersoVideoView`.

The `videoContentMode` property allows you to choose between `aspectFill` and `aspectFit` modes, while the `offsetY` property enables vertical positioning adjustment of the AI Human within the view.

<br/>

```swift
let persoVideoView = PersoVideoView(session: session)

// Set the video content mode (default is aspectFill)
persoVideoView.videoContentMode = .aspectFit

// Adjust vertical offset position (default is 0)
persoVideoView.offsetY = 10.0

persoVideoView.start()
```

If you want to see more information, please navigate to [PersoVideoView](#persovideoview).  

<br/>

### Step 9. Using Features - Standard
#### STT (Speech-to-Text)
STT provides a feature that converts recognized speech from voice data into text. The converted text can be used to compose a chat screen or tailored to meet the user's needs.

```swift
do {
    // input recording audio data or voice data
    let userText = try await session.transcribeAudio(audio: audio, language: "ko")

    // using converted text
} catch {
    // handle STT error
}
```

<br/>

#### LLM (Large-Language-Model)
Completes the chat by generating a response based on the input message using a Large Language Model (LLM).
``` swift
do {
    let sentenceStream = session.completeChat(message: message)

    var contents: [String] = []

    for try await sentence in sentenceStream {
        // delivered sentence by sentence
    }
} catch {
        // handle LLM Completes the chat error
}
```

<br/>

#### TTS (Text-to-Speech)
TTS provides speech synthesis services from text. You only need to send the text you want to synthesize into speech to `PersoVideoView`.

```swift 
// Results obtained through LLM Chat Completion.
persoVideoView.push(text: String)
```

<br/>

It is possible to implement the desired features yourself while using other features provided by the SDK. If you want to learn about customization, please navigate to the [Customization](#customization).

<br/>

## PersoVideoView
Providing a feature to create and display AI Human capable of real-time conversation based on text generated through the pipeline.
  
`PersoVideoView` is required `PersoLiveChatSession`.
  
To use `PersoVideoView`, the `start()` method must be called, but there's an **important** point to consider here.

This method must be called while the app is in the foreground. Attempting to start while the app is in the background will result in a failure to initialize the audio session properly and can cause unexpected errors. If this method is called while the app is in the background, an error will be emitted asynchronously through the delegate method `PersoLiveChatDelegate.didFailWithError(_:)`, instead of immediately throwing an error.

#### PersoVideoViewDelegate
The `PersoVideoViewDelegate` protocol defines a set of methods that can be implemented by a delegate to respond to events that occur in a `PersoVideoView`. By implementing this protocol, you can capture and handle events that arise during the operation of the `PersoVideoView` in your application.

Specifically, the `persoVideoView(didChangeState state: PersoVideoView.PersoVideoViewState)` method detects changes in the state of the `PersoVideoView`, indicating whether it is in the `waiting` state (waiting for a question) or in the `answer` state (responding). This can be used to handle the UI or implement necessary business logic accordingly.

```swift
enum PersoVideoViewState {
    // The view is idle and waiting for new input or a new action.
    case waiting
        
    // The view is actively processing speech synthesis or video-related tasks.
    case processing
}
    
public protocol PersoVideoViewDelegate: AnyObject {
    func persoVideoView(didFailWithError error: PersoLiveChatError)
    func persoVideoView(didChangeState state: PersoVideoView.PersoVideoViewState)
}

// usage
let videoView = PersoVideoView(session: PersoLiveChatSession)

videoView.delegate = self
```

> Note: - These methods are `optional`, and they do not need to be implemented if they are unnecessary.


#### Controlling AI Human

To manage the visibility of the AI Human, use the following methods:

##### Displaying
```swift
/// Start displaying the AI Human
persoVideoView.start()

/// Stop the AI Human display
persoVideoView.stop()

/// Pause the AI Human and Sounds.
persoVideoView.pause()
```

These methods allow you to control when the AI Human is visible and active on the screen.

##### Play Intro Message
When creating a session, an intro message can be specified in the prompt information. If an intro message is set, it can be played immediately at the start using the `playIntro()`.  
The executed intro message can be received through the closure, and additional actions can be performed using the received information.

```swift
/// An intro message is needed in the prompt.

persoVideoView.playIntro { message in
    // handle message such as UI.
}
```

##### Start Speech
To make the AI human speech, simply pass the text you want to synthesize into the `PersoVideoView` using the `push(text:)` method.

```swift
// Start the video view
...

// Make the AI human speech the given text
persoVideoView.push(text: "Hello, how can I assist you today?")
```
> Make sure to handle session status changes, as the session must be active when sending text to the AI for speech synthesis.

##### Stop Speech
If you want to cancel an AI Human response immediately because it's not desired or for any other reason, you can use the `stopSpeech`.

```swift
// Stops the speech synthesis immediately and clears the audio buffer.

await persoVideoView.stopSpeech()
```

<br/>

## Customization
STT, TTS, and LLM can be customized and implemented according to your needs. There are a few rules.

<br/>

### Using Features - TTS Customization

#### Step 1. Implementing Class that conforms to the `SpeechSynthesizable` Protocol.
A custom class that conforms to the `SpeechSynthesizable` protocol needs to be implemented. 

The following information pertains to the `SpeechSynthesizable` protocol interface.
```swift
public protocol SpeechSynthesizable {
    
    /// Synthesizes speech from the given text (Text-to-Speech).
    ///
    /// - Parameters:
    ///   - text: The text string that should be synthesized into speech.
    /// - Returns: A `Data` object representing the synthesized speech audio.
    /// - Throws: An error if the synthesis process fails.
    func synthesizeSpeech(text: String) async throws -> Data
}
```

<br/>

#### Step 2. Pass to the parameters of the `PersoLiveChatSession` initializer.
If you look at the createSession or connectSession initializer information, you can see that the provider can be injected.  

```swift
func createSession(
    for config: Set<SessionCapability> = [],
    modelStyle: ModelStyle,
    provider: (any SpeechSynthesizable)? = nil,
    statusHandler: @escaping (PersoLiveChatSession.SessionStatus) -> Void
) async throws -> PersoLiveChatSession {
    ...
}

func connectSession(
    sessionID: String,
    modelStyle: ModelStyle,
    provider: (any SpeechSynthesizable)? = nil,
    statusHandler: @escaping (PersoLiveChatSession.SessionStatus) -> Void
) async throws -> PersoLiveChatSession {
    ...
}
```

<br/>

## PersoMLComputeUnits
`PersoMLComputeUnits` property specifies the compute resources to be used when executing a Core ML model. By selecting the appropriate compute units, you can balance performance optimization and power efficiency.

The default value is set to `.ane`.

```swift
public enum PersoMLComputeUnits {
    case ane
    case cpu
}

PersoLiveChat.computeUnits = .cpu
```
* `.ane` is available on devices with Apple Neural Engine (A13 Bionic and later) and is recommended for best performance.  
* `.cpu` is universally supported and is ideal for testing or as a fallback strategy.

<br/>
<br/>

## License
PERSO.ai LiveChat SDK for Swift is commercial software. [Contact our sales team](https://perso.ai/contact).