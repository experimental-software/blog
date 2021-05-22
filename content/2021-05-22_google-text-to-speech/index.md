---
title: Google Text to Speech
draft: false
publishedAt: 2021-05-22
---

This blog post shows how to generate MP3 files from text with the Google Cloud speech synthesizer and the Unix command-line interface.

## Setup

To setup the Google Cloud account with the Text-to-Speech functionality, follow [their setup instructions](https://cloud.google.com/text-to-speech/docs/quickstart-protocol?hl=en).

Then you need to export an environment variable with the key file as value.

```bash
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/mykey.json
```

## Request payload

The speech generation request requires the following request payload:

_request.json_:

```json
{
  "input":{
    "text":"This is just a test"
  },
  "voice":{
    "languageCode":"en-gb",
    "name":"en-GB-Standard-A",
    "ssmlGender":"FEMALE"
  },
  "audioConfig":{
    "audioEncoding":"MP3"
  }
}
```

## Generate audio file

The audio file can be generated with cURL like this:

```bash
curl -X POST \
  -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @request.json \
  https://texttospeech.googleapis.com/v1/text:synthesize
``` 

## Convert to MP3

The response for the generation request is a JSON payload which contains an `audioContent` property with the MP3 being a base 64 encoded binary.

```bash
cat response.json | jq -r '.audioContent' | base64 -d > result.mp3
```

## References

- https://cloud.google.com/text-to-speech/docs/quickstart-protocol?hl=en
- [Listing all supported voices](https://cloud.google.com/text-to-speech/docs/list-voices?hl=en)
- [Feature request for support of Punjabi](https://issuetracker.google.com/issues/188855923)
