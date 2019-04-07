module Hp.API where

import Hp.GitHub.Code (GitHubCode)
import Hp.Poll        (Poll)
import Hp.UserId      (UserId)

import Servant
import Servant.API.Generic
import Servant.Auth        (Auth, Cookie)
import Servant.Auth.Server (SetCookie)
import Servant.HTML.Blaze

import qualified Text.Blaze.Html as Blaze


data API route
  = API
  { getRootRoute
      :: route
      :- Auth '[Cookie] UserId
      :> Get '[HTML] Blaze.Html

  , getLoginRoute
      :: route
      :- "login"
      :> Get '[HTML] Blaze.Html

    -- Callback URL used for GitHub OAuth
  , getLoginGitHubRoute
      :: route
      :- "login"
      :> "github"
      :> QueryParam' '[Required, Strict] "code" GitHubCode
      -- TODO required "state" query param
      -- TODO just returning html for now, but should redirect
      :> Get
           '[HTML]
           (Headers
             '[ Header "Set-Cookie" SetCookie
              , Header "Set-Cookie" SetCookie
              ]
           Blaze.Html)

  , postPollRoute
      :: route
      :- "poll"
      :> ReqBody '[JSON] Poll
      :> Post '[JSON] NoContent
  } deriving stock (Generic)
