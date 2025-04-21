use std::borrow::Cow;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub(crate) struct Person {
    pub title: String,
    pub name: Name,
    pub marketing: bool,
}

// Pro tip: Replace String with Cow<'static, str> to
// avoid unnecessary heap allocations when inserting

#[derive(Serialize, Deserialize, Debug)]
pub(crate) struct Name {
    pub first: Cow<'static, str>,
    pub last: Cow<'static, str>,
}