{-# LANGUAGE OverloadedStrings #-}
module Info
    ( twInfo
    ) where

import Web.Twitter.Conduit
import Web.Twitter.Conduit.Stream
import Web.Twitter.Types.Lens

tokens :: OAuth
tokens = twitterOAuth
    { oauthConsumerKey = "something"
    , oauthConsumerSecret = "something"
    }

credential :: Credential
credential = Credential
    [ ("oauth_token", "something")
    , ("oauth_token_secret", "something")
    ]

-- twInfo = setCredential tokens credential def
twInfo :: TWInfo
twInfo = def
    { twToken = def { twOAuth = tokens, twCredential = credential }
    , twProxy = Nothing
    }
