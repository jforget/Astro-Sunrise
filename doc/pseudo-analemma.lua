--[[
     Utility script for Astro::Sunrise's astronomical documentation
     Copyright (C) 2017 Jean Forget

     This program is distributed under the same terms as Perl 5.16.3:
     GNU Public License version 1 or later and Perl Artistic License.

    Here is the summary of GPL:

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 1, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
    Inc., https://www.fsf.org/.
]]

local substr = string.sub;
local floor  = math.floor;
local dq = string.char(34); -- double-quote
local pedag = 8; -- stretch factor for pedagogical purposes

function tim2x(tim)
  local hh = substr(tim, 1, 2);
  local mn = substr(tim, 4, 5);
  local ss = substr(tim, 7, 8);
  return floor(pedag * ((hh - 12) * 10 + mn / 6 + ss / 360));
end

function alt2y(alt)
  local dg = substr(alt, 1, 2);
  local mn = substr(alt, 4, 5);
  local ss = substr(alt, 7, 8);
  return floor(dg + mn / 60 + ss / 3600);
end

function dessin(date)
  -- values obtained from Stellarium
  -- alt12 and alt24: not using the "degree" character U+00B0, because of encoding problems between lua and lualatex
  local t = {
       { date = "2017-01-21", noon = "12:11:24", alt12 = "18 43 46", alt24 = "-58 25 33", label = "J" },
       { date = "2017-02-21", noon = "12:13:35", alt12 = "28 08 20", alt24 = "-49 05 11", label = "F" },
       { date = "2017-03-21", noon = "12:07:08", alt12 = "38 56 42", alt24 = "-38 17 49", label = "M" },
       { date = "2017-04-21", noon = "11:58:41", alt12 = "50 32 27", alt24 = "-26 40 25", label = "A" },
       { date = "2017-05-21", noon = "11:56:38", alt12 = "58 48 02", alt24 = "-18 20 44", label = "M" },
       { date = "2017-06-21", noon = "12:01:52", alt12 = "61 57 27", alt24 = "-15 05 16", label = "J" },
       { date = "2017-07-21", noon = "12:06:28", alt12 = "58 53 35", alt24 = "-18 03 18", label = "J" },
       { date = "2017-08-21", noon = "12:03:07", alt12 = "50 28 12", alt24 = "-26 24 29", label = "A" },
       { date = "2017-09-21", noon = "11:53:02", alt12 = "39 02 20", alt24 = "-37 48 40", label = "S" },
       { date = "2017-10-21", noon = "11:44:38", alt12 = "27 39 33", alt24 = "-49 12 25", label = "O" },
       { date = "2017-11-21", noon = "11:45:58", alt12 = "18 30 28", alt24 = "-58 25 33", label = "N" },
       { date = "2017-12-21", noon = "11:58:13", alt12 = "15 04 59", alt24 = "-61 57 30", label = "D" },
      };
  tex.print("\\begin{mplibcode}\n");
  tex.print("beginfig(1);\n");
  tex.print("draw (-120, 0) -- (120, 0);\n");
  tex.print("draw (0, -90) -- (0, 90);\n");

  -- drawing the pseudo-analemma
  tex.print("draw ");
  for i, v in ipairs(t) do
    local x = tostring(tim2x(v.noon));
    local y = tostring(alt2y(v.alt12));
    tex.print("(" .. x .. ", " .. y .. ")..");
  end
  tex.print("cycle;\n");

  -- labelling the pseudo-analemma
  for i, v in ipairs(t) do
    local x = tostring(tim2x(v.noon));
    local y = tostring(alt2y(v.alt12));
    if (v.date == date) then
      if (substr(v.noon, 1, 2) == "11") then
        tex.print("dotlabel.lft(" .. dq .. v.label .. dq .. ", (" .. x .. ", " .. y .. "));\n");
      else
        tex.print("dotlabel.rt(" .. dq .. v.label .. dq .. ", (" .. x .. ", " .. y .. "));\n");
      end;
      break;
    end
  end
  tex.print("endfig;\n");
  tex.print("\\end{mplibcode}\n");
  tex.print("\\eject\n");
end
